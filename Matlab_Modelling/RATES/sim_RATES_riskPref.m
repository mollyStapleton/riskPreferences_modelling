function [choiceType, totalStim] = sim_RATES_riskPref(params, dist, nIters)

    choiceType   = NaN(nIters, 120);
    totalStim_L  = NaN(nIters, 120);
    totalStim_R  = NaN(nIters, 120);
    p            = NaN(nIters, 120);

    if strcmpi(dist, 'Gaussian')
        dist = 1;
    else 
        dist = 2;
    end

    for i = 1: nIters
    
        R = simulate_rewDist(dist);
        Qt = [params.Q0 params.Q0 params.Q0 params.Q0];
    
        stimCombos       = [12 13 14 21 23 24 31 32 34 41 42 43];
        stimuli(i, :)    = Shuffle(repmat(stimCombos,1,10))';
        stim1            = floor(stimuli(i, :)/10);
        stim2            = stimuli(i, :) - floor(stimuli(i, :)/10)*10;
    
        stimCount  = [0 0 0 0];
        p          = NaN(1, 120);
    
        for t = 1: 120
            stimL = stim1(t);
            stimR = stim2(t);
    
            % softmax to determine choice
            p(i, t)     = exp(params.beta * Qt(stimL))./(exp(params.beta*Qt(stimL)) + exp(params.beta*Qt(stimR)));
    
            if p(i, t) > rand
                % left stimulus chosen
                stimIdx = stimL;
                stimCount(stimIdx) = stimCount(stimIdx) +1;
            else
                % right stimulus chosen
                stimIdx = stimR;
                stimCount(stimIdx) = stimCount(stimIdx) +1;
            end
    
            % only stores relevant choice data for those matched-mean trials,
            % which we use for risk preference calculations
            if (stimuli(i, t) == 12 || stimuli(i, t)  == 21 ||...
                    stimuli(i, t) == 34 || stimuli(i, t)  == 43)
    
                if (stimIdx == 2)
                    % choice LL-RISKY
                    choiceType(i, t) = -1;
                elseif (stimIdx == 4)
                    % choice HH-RISKY
                    choiceType(i, t) = 1;
                end
    
                totalStim_L(i, t) = stimL;
                totalStim_R(i, t) = stimR;
    
            end
    
            % updating of stimulus specific Qt according to delta rule
    
            delta = R{stimIdx}(stimCount(stimIdx)) - Qt(stimIdx);
            if delta > 0 
                alpha2use = params.alpha_pos;
            else 
                alpha2use = params.alpha_neg;
            end

            Qt(stimIdx) =  Qt(stimIdx) + (alpha2use*delta);

    
        end
    end

    %total times RISKY stimuli shown in matched-mean conditions 
    totalStim{1} = (sum(totalStim_L == 2) + sum(totalStim_R == 2));
    totalStim{2} = (sum(totalStim_L == 4) + sum(totalStim_R == 4));

end
