function [NegLL,choiceProb, Qs] = LL_RW_riskPref(dataIn, a, b)

Qt           = [50 50 50 50];
choiceType   = NaN(1, 120);
choiceProb   = NaN(1, 120);
Qs           = NaN(4, 120);

for t = 1: 120
 
    stimL = dataIn.stim_l(t);
    stimR = dataIn.stim_r(t);

    % softmax to determine prob.of choice
    p(t)     = exp(b * Qt(stimL))./(exp(b*Qt(stimL)) + exp(b*Qt(stimR)));
    
    % choice made by subject
    stimIdx(t)  = dataIn.stimulus_choice(t);

    % only stores relevant choice data for those matched-mean trials,
    % which we use for risk preference calculations
    if dataIn.cnd_idx(t) == 2 || dataIn.cnd_idx(t) == 3
        choiceProb(t) = p(t);
        if (stimIdx(t) == 2)
            % choice LL-RISKY
            choiceType(t) = -1;
        elseif (stimIdx(t) == 4)
            % choice HH-RISKY
            choiceType(t) = 1;
        end
    end

    % updating of stimulus specific Qt according to delta rule

    delta = dataIn.reward_obtained(t) - Qt(stimIdx(t));
    Qt(stimIdx(t)) =  Qt(stimIdx(t)) + (a*delta);
    Qs(stimIdx(t), t) = Qt(stimIdx(t));
end

    choiceProb_LL = choiceProb(~isnan(choiceProb));
    % compute negative log-likelihood
    NegLL = -sum(log(choiceProb_LL));

end