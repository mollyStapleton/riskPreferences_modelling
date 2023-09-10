function [best_fit_parm, LL, BIC] = modelFitting_riskPref(dataIn, model, params, dist, distSplit, nIters)

if strcmpi(model, 'RW')
        [best_fit_parm, LL, BIC] = mdlFit_RW_riskPref(dataIn, params, dist, distSplit, nIters);
end

end