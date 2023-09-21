function [meanTrue, meanFit, binnedTrue, binnedFit] = plotFit_RW_riskPref(dataIn, paramFit, dist)

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
    % trial binned risk preference calculations
    bin = [1:24:120];
    binSize = 24;
    for ibin = 1: length(bin)

        trIdx = [];
        trIdx = find(ismember(data2use.trialNum, (bin(ibin): (bin(ibin) + binSize -1)))==1);

        binned_cp{1}(ibin) = nanmean(data2use.choiceProb(data2use.choiceType(trIdx) == -1));
        binned_cp{2}(ibin) = nanmean(data2use.choiceProb(data2use.choiceType(trIdx) == 1));
    
    end

    meanFit(1, :) = nanmean(data2use.choiceProb(data2use.choiceType == -1));
    meanFit(2, :) = nanmean(data2use.choiceProb(data2use.choiceType == 1));

    binnedFit =binned_cp;
    
end 