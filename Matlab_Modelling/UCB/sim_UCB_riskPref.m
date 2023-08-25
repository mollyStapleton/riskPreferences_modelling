function [Qall, choiceType, totalStim] = sim_UCB_riskPref(params, dist, nIters)

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
        Rt = [50 50 50 50];
    

        stimCombos       = [12 13 14 21 23 24 31 32 34 41 42 43];
        stimuli(i, :)    = Shuffle(repmat(stimCombos,1,10))';
        stim1            = floor(stimuli(i, :)/10);
        stim2            = stimuli(i, :) - floor(stimuli(i, :)/10)*10;
    
        stimCount  = [1 1 1 1]; %UCB assumes each arm already sampled once
        p          = NaN(1, 120);
        Qtrack     = NaN(120, 4);

        for t = 1: 120-1
            stimL = stim1(t);
            stimR = stim2(t);
    
            % UCB rather than softmax to determine choice
%             V1(t)  = Qt(stimL) + (params.c *(sqrt(2*log(t)./stimCount(stimL))));
%             V2(t)  = Qt(stimR) + (params.c *(sqrt(2*log(t)./stimCount(stimR))));
            UCB_v = [Qt(stimL) Qt(stimR)] + (params.c *(sqrt(2*log(t)./ ...
                max([stimCount(stimL) stimCount(stimR)]))));

            if UCB_v(1) == UCB_v(2) % if UCB for each arm is equal randomly select one arm
%                 p(i, t)     = exp(params.beta * V1)./(exp(params.beta*V1) + exp(params.beta*V2));
               rndIdx  = randi([1, 2]);
               if rndIdx == 1 
                    stimIdx = stimL;
               else
                   stimIdx = stimR;
               end
               
            else % UCB chooses the arm with maximum estimates value
                choiceIdx = find(UCB_v == (max([UCB_v])));
                if choiceIdx == 1 
                    stimIdx = stimL;
                else 
                    stimIdx = stimR;
                end

            end
    
            stimCount(stimIdx) = stimCount(stimIdx) +1;
    
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
            % delta = R{stimIdx}(stimCount(stimIdx)) - Qt(stimIdx);

            % updating total amount of rewards obtained in relation to each
            % stimulus choice

            Rt(stimIdx) = Rt(stimIdx) + R{stimIdx}(stimCount(stimIdx));

            % updating of estimated values
            Qt(stimIdx) =  (Rt(stimIdx) ./stimCount(stimIdx))...
                +(params.c * sqrt(2*log(t)./stimCount(stimIdx)));
            Qtrack(t, stimIdx) = Qt(stimIdx);
    
        end
        for istim = 1:4
           Qall{istim}(i, :) =  Qtrack(:, istim);
        end
    end

    %total times RISKY stimuli shown in matched-mean conditions 
    totalStim{1} = (sum(totalStim_L == 2) + sum(totalStim_R == 2));
    totalStim{2} = (sum(totalStim_L == 4) + sum(totalStim_R == 4));

end
