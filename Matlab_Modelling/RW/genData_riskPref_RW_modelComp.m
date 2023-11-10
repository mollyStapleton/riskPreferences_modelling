function [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit,...
    accTrue_binned, accFit_binned] = genData_riskPref_RW_modelComp(dataIn, paramFit, dist)

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

% assigned choice probabilities to the separate blocks 
blockNum = unique(data2use.blockNumber);
data2use.choiceProb_mdlFit = NaN(1, size(data2use, 1))';
for iblock = 1: length(blockNum)
    data2use.choiceProb_mdlFit(data2use.blockNumber == blockNum(iblock)) = choiceProb(iblock, :);    
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
        stimIdx = find(data2use.stimComboIdx == stimCombo{icnd}(icmb));
        tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx)];

    end
    meanFit(icnd) = mean(tmp);
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
            tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx)];
            binnedFit{icnd}(ibin) = mean(tmp);
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
        tmp     = [tmp; data2use.choiceProb_mdlFit(stimIdx)];
        fullIdx = [fullIdx; stimIdx];
    end
    accFit(istim) = mean(tmp);
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
            tmp = [tmp; data2use.choiceProb_mdlFit(stimIdx)];
            fullIdx = [fullIdx; stimIdx];
        end
        accFit_binned(istim, ibin) = mean(tmp);
        accTrue_binned(istim, ibin) =  sum(data2use.choice_high(fullIdx) == 1)./length(fullIdx);
    end
end

data2plot.meanTrue          = meanTrue;
data2plot.meanFit           = meanFit;
data2plot.binnedTrue        = binnedTrue;
data2plot.binnedFit         = binnedFit;
data2plot.accFit            = accFit;
data2plot.accTrue           = accTrue;
data2plot.accFit_binned     = accFit_binned;
data2plot.accTrue_binned    = accTrue_binned;

plotSubjectFit_RW(data2plot, paramFit, dist);


end