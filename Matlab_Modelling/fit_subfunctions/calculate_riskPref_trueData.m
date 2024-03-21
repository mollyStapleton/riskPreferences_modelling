function [riskyChoiceTrue, binnedRisk] = calculate_riskPref_trueData(data2use, dist)


    %calculate overall risk preferences 
    LL = length(find(data2use.cnd_idx == 2));
    HH = length(find(data2use.cnd_idx == 3));
    LL_risk = sum(data2use.choiceType == -1);
    HH_risk = sum(data2use.choiceType == 1);
    riskyChoiceTrue(1) = LL_risk./LL;
    riskyChoiceTrue(2) = HH_risk./HH;

    % trial binned risk preference calculations
    bin = [1:24:120];
    binSize = 24;
    for ibin = 1: length(bin)

        trIdx = [];
        trIdx = find(ismember(data2use.trialNum, (bin(ibin): (bin(ibin) + binSize -1)))==1);
        binnedRisk{1}(ibin) = sum(data2use.choiceType(trIdx) == -1 )./ sum(data2use.cnd_idx(trIdx) == 2);
        binnedRisk{2}(ibin) = sum(data2use.choiceType(trIdx) == 1 )./ sum(data2use.cnd_idx(trIdx) == 3);
        

    end

end
