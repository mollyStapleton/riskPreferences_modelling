function [meanTrue, meanFit, binnedTrue, binnedFit, accTrue,...
    accFit, accTrue_binned, accFit_binned] = genData_riskPref_modelComp(dataIn, paramFit, model, dist)

% if strcmpi(model, 'RW')
   [meanTrue, meanFit, binnedTrue, binnedFit, accTrue, accFit,...
       accTrue_binned, accFit_binned] = genData_riskPref_RW_modelComp(dataIn, paramFit, model, dist);
% end



end