function [p_risky_t, p_high_t, Qall] = sim_RATES_riskPref(params, dist, nIters)

    choiceType   = NaN(nIters, 120);
    choiceHigh   = NaN(nIters, 120);
    totalStim_L  = NaN(nIters, 120);
    totalStim_R  = NaN(nIters, 120);
    p            = NaN(nIters, 120);
    p_choice_l   = NaN(nIters, 120);
    % data for accuracy
    stimChosen   = NaN(nIters, 120);

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
        Qtrack     = NaN(120, 4);

        for t = 1: 120
            stimL = stim1(t);
            stimR = stim2(t);
    
            % softmax to determine choice
            p(i, t)     = exp(params.beta * Qt(stimL))./(exp(params.beta*Qt(stimL)) + exp(params.beta*Qt(stimR)));
    
            if p(i, t) > rand
                % left stimulus chosen
                stimIdx = stimL;
                stimCount(stimIdx) = stimCount(stimIdx) +1;
                p_choice_l(i, t)   = p(i, t);
            else
                % right stimulus chosen
                stimIdx = stimR;
                stimCount(stimIdx) = stimCount(stimIdx) +1;
            end

            stimChosen(i, t) = stimIdx;

            % only stores relevant choice data for those matched-mean trials,
            % which we use for risk preference calculations
            if (stimuli(i, t) == 12 || stimuli(i, t)  == 21 ||...
                    stimuli(i, t) == 34 || stimuli(i, t)  == 43)

                if (stimChosen(i, t) == 2)
                    % choice LL-RISKY
                    choiceType(i, t) = -1;
                elseif (stimChosen(i, t) == 4)
                    % choice HH-RISKY
                    choiceType(i, t) = 1;
                end

                totalStim_L(i, t) = stimL;
                totalStim_R(i, t) = stimR;

            else
                if stimChosen(i, t) == 3 || stimChosen(i, t) == 4
                    choiceHigh(i, t) = 1;
                end
            end

            % updating of stimulus specific Qt according to delta rule
    
            delta = R{stimIdx}(stimCount(stimIdx)) - Qt(stimIdx);
            if delta > 0 
                alpha2use = params.alpha_pos;
            else 
                alpha2use = params.alpha_neg;
            end

            Qt(stimIdx) =  Qt(stimIdx) + (alpha2use*delta);
            Qtrack(t, stimIdx) = Qt(stimIdx);
    
        end

          for istim = 1:4
            Qall{istim}(i, :) =  Qtrack(:, istim);
          end
    end

%---------------------------------------------------------------------
% Generate average data for plotting
%---------------------------------------------------------------------
% matched mean condition stimulus combination
%----------------------------------------------------------
stimCombo = {[21 12], [43 34]};

%------------------------------------------------------------------
% OVERALL P(RISKY)
%--------------------------------------------------------------------------

for t = 1:120
    for icnd = 1:2
        tmp_binary = [];
        tmp        = [];
        for icmb = 1:2
            stimIdx = [];
            stimIdx = find(stimuli(:, t) == stimCombo{icnd}(icmb));
            tmp     = [tmp; choiceType(stimIdx, t)];
%               tmp     = [tmp; p_choice_l(stimIdx, t)];

        end
%         p_risky_t(icnd, t) = nanmean(tmp);
%           tmp     = [tmp; p_choice_l(stimIdx, t)];
        p_risky_t(icnd, t) = sum(~isnan(tmp))./length(tmp);
    end
end


%---------------------------------------------------------------------------
%%% CALCULATE THE P(HIGH)
%----------------------------------------------------------------------------------
%%% OVERALL
%------------------------------------------------------------------------------
stimHighIdx = {[31 13] [32 23] [41 14] [42 24]};
% HH-Safe:LL-Safe HH-Safe:LL-Risky, HH-Risky:LL-Safe, HH-Risky:LL-Risky
for t = 1:120
    for istim = 1:4
        tmp = [];

        for icmb = 1:2
            stimIdx = [];
            stimIdx = find(stimuli(:, t) == stimHighIdx{istim}(icmb));
            tmp     = [tmp; choiceHigh(stimIdx, t)];
%             tmp     = [tmp; p_choice_l(stimIdx, t)];

        end
%         p_high_t(istim, t) = nanmean(tmp);
        p_high_t(istim, t) = sum(~isnan(tmp))./length(tmp);
    end
end

end

