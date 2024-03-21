function [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit,...
    accTrue_binned, accFit_binned] = genData_riskPref_modelComp_joint(dataIn, paramFit, model)

for idist = 1:2

    data2use = []

    if idist == 1 %Gaussian
        distIdx   = 1
        params.Q0 = [50 50 50 50];
    else
        distIdx   = 2
        params.Q0 = [0 0 0 0];
    end

    data2use = dataIn(dataIn.distType == distIdx, :);

    % calculate risk preference from TRUE data
    [meanTrue, binnedTrue] = calculate_riskPref_trueData(data2use, dist);

    % simulate data fit using parameter fits

    if strcmpi(model, 'RW')

        [NegLL,choiceProb, ~, Qs] = LL_RW_riskPref(data2use, paramFit.fittedParams(1), paramFit.fittedParams(2));

    elseif strcmpi(model, 'RATES')

        [NegLL,choiceProb, ~, Qs] = LL_RATES_riskPref(data2use, paramFit.fittedParams(1), paramFit.fittedParams(2), paramFit.fittedParams(3));

    elseif strcmpi(model, 'UCB_nCount')

        [NegLL,choiceProb, ~, Qs] = LL_UCB_nCount_riskPref(data2use, paramFit.fittedParams(1), paramFit.fittedParams(2), paramFit.fittedParams(3));

    elseif strcmpi(model, 'UCB_spread')

        [NegLL,choiceProb, ~, Qs] = LL_UCB_spread_riskPref(data2use, paramFit.fittedParams(1), paramFit.fittedParams(2), paramFit.fittedParams(3), paramFit.fittedParams(4), paramFit.fittedParams(5));

    elseif strcmpi(model, 'PEIRS')

        [NegLL,choiceProb, ~, Qs] = LL_PEIRS_riskPref(data2use, paramFit.fittedParams(1), paramFit.fittedParams(2), paramFit.fittedParams(3), paramFit.fittedParams(4), paramFit.fittedParams(5));
    end

    % assigned choice probabilities to the separate blocks 
    blockNum = unique(data2use.blockNumber);
    data2use.choiceProb_mdlFit = NaN(1, size(data2use, 1))';
    for iblock = 1: length(blockNum)
        data2use.choiceProb_mdlFit(data2use.blockNumber == blockNum(iblock)) = choiceProb(iblock, :); 
        data2use.choiceDir(data2use.blockNumber == blockNum(iblock)) = data2use.chosen_dir(data2use.blockNumber == blockNum(iblock))-1;
    end
    
end


end
