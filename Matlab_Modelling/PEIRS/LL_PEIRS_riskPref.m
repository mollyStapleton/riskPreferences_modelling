function [NegLL,choiceProb, choice_dir, Qs] = LL_PEIRS_riskPref(dataIn_all, aQ, aS, b, S0, O)

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
    PEIRS_s                 = NaN(4, nTrials);
       

    for t = 1: nTrials
    
        stimL = dataIn.stim_l(t);
        stimR = dataIn.stim_r(t);

        % stimulus prediction error 
        delta_stim(t) = ( Qt(stimL) + Qt(stimR) ) / 2 - sum(Qt(1:4)) / 4;
        PEIRS(t) = tanh(O * delta_stim(t));

        % softmax to determine choice
        v1          = Qt(stimL) + PEIRS(t) * St(stimL);
        v2          = Qt(stimR) + PEIRS(t) * St(stimR);

        p(t)     = exp(b * v1)./(exp(b*v1) + exp(b*v2));

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
            PEIRS_s(t, stimIdx(t)) = PEIRS(t);
            Ss(stimIdx(t), t) = St(stimIdx(t));

        end
    end

    choice_dir(isnan(p)) = [];
    p=0.99*p+0.005;
    p(isnan(p)) = [];

    % compute negative log-likelihood
    NegLL(iblock) = -sum(log(binopdf(choice_dir,1,p)));

end

NegLL = sum(NegLL);