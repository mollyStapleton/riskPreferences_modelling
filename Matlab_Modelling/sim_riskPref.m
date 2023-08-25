function sim_riskPref(model, params, dist, nIters)

if strcmpi(model, 'RW')
    [choiceType, totalStim] = sim_RW_riskPref(params, dist, nIters);
end
if strcmpi(model, 'RATES')
    [choiceType, totalStim] = sim_RATES_riskPref(params, dist, nIters);
end



plot_riskPref(choiceType, totalStim, model, dist, params);


end