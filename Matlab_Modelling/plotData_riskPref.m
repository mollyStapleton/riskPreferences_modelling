function [meanTrue, meanFit, binnedTrue, binnedFit] = plotFit_riskPref(dataIn, paramFit, model, dist)

if strcmpi(model, 'RW')
   [meanTrue, meanFit, binnedTrue, binnedFit] = plotData_RW_riskPref(dataIn, paramFit, dist);
end

end