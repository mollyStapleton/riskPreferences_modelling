function [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit] = plotFit_RW_riskPref(dataIn, paramFit, dist)

    if strcmp(dist, 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    else 
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    end
    if strcmpi(dist, 'Gaussian')
        data2use = dataIn(dataIn.distType == 1, :);
    else 
        data2use = dataIn(dataIn.distType == 2, :);
    end
    
%     data2use = data2use((1:120), :);
   

    % calculate risk preference from TRUE data
    [meanTrue, binnedTrue] = calculate_riskPref_trueData(data2use, dist);

    % simulate data fit using parameter fits 
    params.Q0 = [50 50 50 50];
    params.alpha = paramFit.alpha;
    params.beta  = paramFit.beta;

    [NegLL,choiceProb, choice_dir, Qs] = LL_RW_riskPref(data2use, paramFit.alpha, paramFit.beta);

    data2use.choiceProb = choiceProb';
    data2use.choiceL    = choice_dir';

    % overall p(risky)
    stimCombo = {[21 12], [43 34]};

    for icnd = 1:2

        tmp = [];

        for icmb = 1:2

            stimIdx = [];
            stimIdx = find(data2use.stimComboIdx == stimCombo{icnd}(icmb));
            if icmb == 1 % risky stimulus is on the LEFT
                tmp     = [tmp; data2use.choiceProb(stimIdx)];
            else 
                tmp     = [tmp; 1 - data2use.choiceProb(stimIdx)];
            end
        
        end

        meanFit(icnd) = mean(tmp);
    end

    

    % trial binned risk preference calculations
    bin = [1:24:120];
    binSize = 24;
    binnedFit = [];

    for icnd = 1:2
        
        for ibin = 1: length(bin)
    
            trIdx = [];
            trIdx = find(ismember(data2use.trialNum, (bin(ibin): (bin(ibin) + binSize -1)))==1);
            tmp   = [];

            for icmb = 1:2

                stimIdx = [];
                stimIdx = trIdx(data2use.stimComboIdx(trIdx) == stimCombo{icnd}(icmb));
                if icmb == 1 % risky stimulus is on the LEFT
                    tmp     = [tmp; data2use.choiceProb(stimIdx)];
                else
                    tmp     = [tmp; 1 - data2use.choiceProb(stimIdx)];
                end
            end

            binnedFit{icnd}(ibin) = mean(tmp);
            
        end
    end

    % return p(High) for all 4 of the unmatched conditions 
    % 3 and 4 are the high stimuli
    stimHighIdx = {[41 14], [31 13], [32 23], [42 24]};
    for istim = 1:4
        tmp = [];

        for ibin = 1: length(bin)
    
            trIdx = [];
            trIdx = find(ismember(data2use.trialNum, (bin(ibin): (bin(ibin) + binSize -1)))==1);
            tmp   = [];
            fullIdx = [];
            
                for icmb = 1:2
                    stimIdx = [];
                    stimIdx = trIdx(data2use.stimComboIdx(trIdx) == stimHighIdx{istim}(icmb));
                    if icmb == 1 
                        tmp = [tmp; data2use.choiceProb(stimIdx)];
                    else 
                        tmp = [tmp; 1- data2use.choiceProb(stimIdx)];
                    end
             
                    fullIdx = [fullIdx; stimIdx];
                    
                end

        accFit(istim, ibin) = mean(tmp);

        accTrue(istim, ibin) =  sum(data2use.choice_high(fullIdx) == 1)./length(fullIdx);

    end

    
    end 

end