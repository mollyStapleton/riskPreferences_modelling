function [data2plot] = genData_riskPref_modelComp(dataIn, paramFit, model, dist)

if strcmpi(dist, 'Joint')
    distsLoop = 2;
else 
    distsLoop = 1;
end

for idist = 1: distsLoop
    data2use = []

    if ~strcmpi(dist, 'Joint')
        if strcmp(dist, 'Gaussian')
            col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
            data2use = dataIn(dataIn.distType == 1, :);
            params.Q0 = [50 50 50 50];
        else
            col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
            data2use = dataIn(dataIn.distType == 2, :);
            params.Q0 = [0 0 0 0];
        end
    else
        if idist == 1 %Gaussian
            params.Q0 = [50 50 50 50];
            data2use = dataIn(dataIn.distType == 1, :);
            dist2plot = 'Gaussian';
        else
            distIdx   = 2
            params.Q0 = [0 0 0 0];
            data2use = dataIn(dataIn.distType == 2, :);
            dist2plot = 'Bimodal';
        end
    end

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
    %---------------------------------------------------------------------------
    %%% CALCULATE THE P(RISKY)
    %----------------------------------------------------------------------------------
    %%% OVERALL
    %------------------------------------------------------------------------------
    stimCombo = {[21 12], [43 34]};
    for icnd = 1:2
        tmp = [];
        for icmb = 1:2
            stimIdx = [];
            % identify trials that match searched stimulus combination
            % presentation is side counterbalanced
            stimIdx = find(data2use.stimComboIdx == stimCombo{icnd}(icmb));
            if icmb == 1
                tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
            else
                tmp     = [tmp; 1 - data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
            end

        end
        meanFit(icnd) = nanmean(tmp);
    end
    %----------------------------------------------------------------------------------
    %%% TRIAL BINNED
    %------------------------------------------------------------------------------
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
                if icmb == 1
                    tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
                else
                    tmp     = [tmp; 1 - data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
                end
                binnedFit{icnd}(ibin) = nanmean(tmp);
            end
        end
    end
    %---------------------------------------------------------------------------
    %%% CALCULATE THE P(HIGH)
    %----------------------------------------------------------------------------------
    %%% OVERALL
    %------------------------------------------------------------------------------
    stimHighIdx = {[31 13] [32 23] [41 14] [42 24]};
    % HH-Safe:LL-Safe HH-Safe:LL-Risky, HH-Risky:LL-Safe, HH-Risky:LL-Risky
    for istim = 1:4
        tmp = [];
        fullIdx = [];
        for icmb = 1:2
            stimIdx = [];
            stimIdx = find(data2use.stimComboIdx == stimHighIdx{istim}(icmb));
            if icmb == 1
                tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
            else
                tmp     = [tmp; 1 - data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
            end
            fullIdx = [fullIdx; stimIdx];
        end
        accFit(istim) = nanmean(tmp);
        accTrue(istim) = sum(data2use.choice_high(fullIdx)==1)./length(fullIdx);
    end
    %----------------------------------------------------------------------------------
    %%% TRIAL BINNED
    %------------------------------------------------------------------------------
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
                    tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
                else
                    tmp     = [tmp; 1 - data2use.choiceProb_mdlFit(stimIdx(data2use.choiceDir(stimIdx)==1))];
                end
                fullIdx = [fullIdx; stimIdx];
            end
            accFit_binned(istim, ibin) = nanmean(tmp);
            accTrue_binned(istim, ibin) =  sum(data2use.choice_high(fullIdx) == 1)./length(fullIdx);
        end
    end

    data2plot.meanTrue(idist, :)       = meanTrue;
    data2plot.meanFit(idist, :)        = meanFit;
    data2plot.binnedTrue{idist}        = cell2mat(binnedTrue');
    data2plot.binnedFit{idist}         = cell2mat(binnedFit');
    data2plot.accFit(idist, :)         = accFit;
    data2plot.accTrue(idist, :)        = accTrue;
    data2plot.accFit_binned{idist}     = accFit_binned;
    data2plot.accTrue_binned{idist}    = accTrue_binned;


end

    if ~strcmpi(dist, 'Joint')
        plotSubjectFit(data2plot, paramFit, model, dist);
    else
        plotSubjectFit_joint(data2plot, paramFit, model, dist);
    end

end