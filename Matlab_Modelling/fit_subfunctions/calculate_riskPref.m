function [data_all, data_binned] = calculate_riskPref(choiceType, totalStim)


    % single trial risk preference calculations
    for itrial = 1:120
        risky_choice{1}(itrial) = sum(choiceType(:, itrial) == -1)./totalStim{1}(itrial);
        risky_choice{2}(itrial) = sum(choiceType(:, itrial) == 1)./totalStim{2}(itrial);
    end

    % trial binned risk preference calculations
    bin = [1:24:120];
    binSize = 24;
    for ibin = 1: length(bin)

        meanRisk{1}(ibin) = nanmean(risky_choice{1}(bin(ibin): (bin(ibin) + binSize -1)));
        semRisk{1}(ibin) = nanstd(risky_choice{1}(bin(ibin): (bin(ibin) + binSize -1)))...
            ./sqrt(length(risky_choice{1}(bin(ibin): (bin(ibin) + binSize -1))));

        meanRisk{2}(ibin) = nanmean(risky_choice{2}(bin(ibin): (bin(ibin) + binSize -1)));
        semRisk{2}(ibin) = nanstd(risky_choice{2}(bin(ibin): (bin(ibin) + binSize -1)))...
            ./sqrt(length(risky_choice{2}(bin(ibin): (bin(ibin) + binSize -1))));

    end

    data_all = risky_choice;
    data_binned = [meanRisk; semRisk];

end
