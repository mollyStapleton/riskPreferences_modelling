function [NegLL,choiceProb, choice_dir, Qs] = LL_UCB_spread_riskPref(dataIn_all, aQ, aS, b, c, S0)

blockNums = unique(dataIn_all.blockNumber);

for iblock = 1:length(blockNums)
    
    dataIn                  = [];
    dataIn                  = dataIn_all(dataIn_all.blockNumber == blockNums(iblock), :);
    nTrials                 = size(dataIn, 1);

    distIdx = dataIn_all.distType(1);
    if distIdx == 1
        Qstart = 50;
    else
        Qstart = 0;
    end

    Qt                      = [Qstart Qstart Qstart Qstart]*0+Qstart;
    St                      = [S0 S0 S0 S0];
    choice_dir              = zeros(1, nTrials);
    choiceProb(iblock, :)   = NaN(1, nTrials);
    choiceProb_LL(iblock, :)= NaN(1, nTrials);
    Qs                      = NaN(4, nTrials);
    Ss                      = NaN(4, nTrials);
    UCB_s                   = NaN(4, nTrials);
    UCB_v                   = [50 50 50 50]; %assuming each arm has already been sampled once
        

    for t = 1: nTrials
    
        stimL = dataIn.stim_l(t);
        stimR = dataIn.stim_r(t);

        % based on choice history, update the uncertainty bonus
        % associated with each stimulus
        UCB_v = (c *(sqrt(2*log(t)./St)));

        % softmax to determine choice
        p(t)     = exp(b * (Qt(stimL) + UCB_v(stimL)))./...
            (exp(b*(Qt(stimL) + UCB_v(stimL))) + exp(b* (Qt(stimR) + UCB_v(stimR))));


        % choice made by subject
        stimIdx(t)  = dataIn.stimulus_choice(t);
    
        % binary vector of 0 1 to indicate choice made to left target
        if stimL == stimIdx(t)
            choice_dir(1, t) = 1;
        else % p(right)
            choice_dir(1, t) = 0;
%             p(t)=1-p(t);
        end
    
        % probability of choosing left target
        choiceProb(iblock, t) = p(t);
    
        % updating of stimulus specific Qt according to delta rule
        if ((stimIdx(t)))~=0
           % updating of stimulus specific Qt according to delta rule
            delta = dataIn.reward_obtained(t) - Qt(stimIdx(t));
            Qt(stimIdx(t)) =  Qt(stimIdx(t)) + (aQ*delta);
            
            % updating of stimulus specific St
            delta_s = abs(delta) - St(stimIdx(t));
            St(stimIdx(t)) = St(stimIdx(t)) + (aS*delta_s);
            
            Qs(stimIdx(t), t) = Qt(stimIdx(t));
            UCB_s(t, stimIdx(t)) = UCB_v(stimIdx(t));
            Ss(stimIdx(t), t) = St(stimIdx(t));

        end
        %[stimL stimR dataIn.stimulus_choice(t) dataIn.reward_obtained(t) Qt p(t)]
    end

    %     choiceProb(choice_dir==0)=1-choiceProb(choice_dir==0);
    %     choiceProb(iblock, :)=0.99*choiceProb(iblock, :)+0.005;
    %     choiceProb_LL(iblock, ~isnan(choiceProb(iblock, :))) = choiceProb(iblock, ~isnan(choiceProb(iblock, :)));
    %     % compute negative log-likelihood
    %     NegLL(iblock) = -sum(log(choiceProb_LL(iblock, :)));

    choice_dir(isnan(p)) = [];
    p=0.99*p+0.005;
    p(isnan(p)) = [];

    % compute negative log-likelihood
    NegLL(iblock) = -sum(log(binopdf(choice_dir,1,p)));

end

NegLL = sum(NegLL);