function [Qall, Sall, choiceType, totalStim] = sim_PEIRS_riskPref(params, dist, nIters)

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
        St = [params.S0 params.S0 params.S0 params.S0];

        stimCombos       = [12 13 14 21 23 24 31 32 34 41 42 43];
        stimuli(i, :)    = Shuffle(repmat(stimCombos,1,10))';
        stim1            = floor(stimuli(i, :)/10);
        stim2            = stimuli(i, :) - floor(stimuli(i, :)/10)*10;
    
        stimCount  = [0 0 0 0];
        p          = NaN(1, 120);
        Qtrack     = NaN(120, 4);
        Strack     = NaN(120, 4);
        
        for t = 1: 120
            stimL = stim1(t);
            stimR = stim2(t);

            % stimulus prediction error 
            delta_stim(t) = ( Qt(stimL) + Qt(stimR) ) / 2 - sum(Qt(1:4)) / 4;
            PEIRS(t)      = tanh(params.omega);
            % softmax to determine choice
            v1          = Qt(stimL) + PEIRS(t) + St(stimL);
            v2          = Qt(stimR) + PEIRS(t) + St(stimR);

            p(i, t)     = exp(params.beta * v1)./(exp(params.beta*v1) + exp(params.beta*v2));
    
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
            % updating of stimulus specific St 
            delta_s = abs(delta) - St(stimIdx);

            Qt(stimIdx) =  Qt(stimIdx) + (params.alphaQ *delta);
            St(stimIdx) =  St(stimIdx) + (params.alphaS * delta_s);
            
            Qtrack(t, stimIdx) = Qt(stimIdx);
            Strack(t, stimIdx) = St(stimIdx);
        end

          for istim = 1:4
           Qall{istim}(i, :) =  Qtrack(:, istim);
           Sall{istim}(i, :) =  Strack(:, istim);
          end

    end

    %total times RISKY stimuli shown in matched-mean conditions 
    totalStim{1} = (sum(totalStim_L == 2) + sum(totalStim_R == 2));
    totalStim{2} = (sum(totalStim_L == 4) + sum(totalStim_R == 4));

end