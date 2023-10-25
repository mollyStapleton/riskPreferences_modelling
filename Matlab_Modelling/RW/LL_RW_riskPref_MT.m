function [NegLL,choiceProb, choice_dir, Qs] = LL_RW_riskPref_MT(dataIn, a, b)

nTrials      = size(dataIn, 1);
Qt           = [50 50 50 50]*0+50;
choice_dir   = zeros(1, nTrials);
choiceProb   = NaN(1, nTrials);
Qs           = NaN(4, nTrials);
choicemdl    = NaN(nTrials,2);
hum=table2array(dataIn(:,6:7));
ch=table2array(dataIn(:,9));
choicehum= (hum==ch);
for t = 1: nTrials

    stimL = dataIn.stim_l(t);
    stimR = dataIn.stim_r(t);

    % softmax to determine prob.of choice
    p(t)     = exp(b * Qt(stimL))./(exp(b*Qt(stimL)) + exp(b*Qt(stimR)));

    % choice made by subject
    stimIdx(t)  = dataIn.stimulus_choice(t);

    % binary vector of 0 1 to indicate choice made to left target
    if stimL == stimIdx(t);
        choice_dir(t) = 1;
    else
        p(t)=1-p(t);
    end
    choicemdl(t,1)=p(t);  % p(choice|left)
    choicemdl(t,2)=1-p(t);% p(choice|right)

    % probability of choosing left target
    choiceProb(t) = p(t);

    % updating of stimulus specific Qt according to delta rule
    if ((stimIdx(t)))~=0
        delta = dataIn.reward_obtained(t) - Qt(stimIdx(t));
        Qt(stimIdx(t)) =  Qt(stimIdx(t)) + (a*delta);
        Qt=max(0,Qt);
        Qs(stimIdx(t), t) = Qt(stimIdx(t));
    end
    %[stimL stimR dataIn.stimulus_choice(t) dataIn.reward_obtained(t) Qt p(t)]
end

%%%% By Molly
%%choiceProb(choice_dir==0)=1-choiceProb(choice_dir==0);
%     choiceProb=0.99*choiceProb+0.005;
%     choiceProb_LL = choiceProb(~isnan(choiceProb));
%     % compute negative log-likelihood
%     NegLL = -sum(log(choiceProb_LL));

%%%% by Maryam

choiceProb_LL = choiceProb(~isnan(choiceProb));
choiceProb_LL(choiceProb_LL==0) = eps;
NegLL = -sum(log(choiceProb_LL));

% choicemdl_LL  = choicemdl(~isnan(choiceProb),:);
% choicehum_LL  = choicehum(~isnan(choiceProb),:);
% L = choicemdl_LL.^choicehum_LL;
% L(L==0) = eps;
% NegLL   = -sum(nansum(log(L),2));

end