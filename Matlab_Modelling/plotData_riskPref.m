function [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit] = plotFit_riskPref(dataIn, paramFit, model, dist)

if strcmpi(model, 'RW')
   [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit] = plotData_RW_riskPref(dataIn, paramFit, dist);
end

end