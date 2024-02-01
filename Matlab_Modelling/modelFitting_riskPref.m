function [best_fit_parm, LL, BIC] = modelFitting_riskPref(dataIn, model, params, dist, distSplit, nIters)

p = gcp('nocreate');
if ~isempty(p)
    Nwork = p.NumWorkers;
else
    Nwork = 0;
end
if Nwork ~= 4
  delete(gcp('nocreate'))
%   parpool('local', 4, 'IdleTimeout', 30);
  parpool('local', 4);
end


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