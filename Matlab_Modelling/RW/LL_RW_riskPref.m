function [NegLL,choiceProb, Qs] = LL_RW_riskPref(dataIn, a, b)

Qt           = [50 50 50 50];
choice_dir   = zeros(1, 120);
choiceProb   = NaN(1, 120);
Qs           = NaN(4, 120);

for t = 1: 120
 
    % choice made by subject
    stimIdx(t)  = dataIn.stimulus_choice(t);

    if stimIdx(t) ~= 0
        stimL = dataIn.stim_l(t);
        stimR = dataIn.stim_r(t);
    
        % softmax to determine prob.of choice
        p(t)     = exp(b * Qt(stimL))./(exp(b*Qt(stimL)) + exp(b*Qt(stimR)));
        
        % choice made by subject
        stimIdx(t)  = dataIn.stimulus_choice(t);

    
        % binary vector of 0 1 to indicate choice made to left target 
        if stimL == stimIdx(t);
            choice_dir(t) = 1;
        end
    
        % probability of choosing left target 
        choiceProb(t) = p(t);
    
        % updating of stimulus specific Qt according to delta rule
    
        delta = dataIn.reward_obtained(t) - Qt(stimIdx(t));
        Qt(stimIdx(t)) =  Qt(stimIdx(t)) + (a*delta);
        Qs(stimIdx(t), t) = Qt(stimIdx(t));
    end
end

    choiceProb_LL = choiceProb(~isnan(choiceProb));
    % compute negative log-likelihood
    NegLL = -sum(log(choiceProb_LL));

end