function [best_fit_parm, LL, BIC] = modelFitting_riskPref(dataIn, model, params, dist, distSplit, nIters)

if strcmpi(model, 'RW')
        [best_fit_parm, LL, BIC] = mdlFit_RW_riskPref(dataIn, params, dist, distSplit, nIters);
end

if strcmpi(model, 'RATES')
        [best_fit_parm, LL, BIC] = mdlFit_RATES_riskPref(dataIn, params, dist, distSplit, nIters);
end

if strcmpi(model, 'UCB_nCount')
        [best_fit_parm, LL, BIC] = mdlFit_UCB_nCount_riskPref(dataIn, params, dist, distSplit, nIters);
end

if strcmpi(model, 'UCB_spread')
        [best_fit_parm, LL, BIC] = mdlFit_UCB_spread_riskPref(dataIn, params, dist, distSplit, nIters);
end


end