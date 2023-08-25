function sim_riskPref(model, params, dist, nIters)

if strcmpi(model, 'RW')
    [Qall, choiceType, totalStim] = sim_RW_riskPref(params, dist, nIters);
end
if strcmpi(model, 'RATES')
    [Qall, choiceType, totalStim] = sim_RATES_riskPref(params, dist, nIters);
end
if strcmpi(model, 'UCB')
    [Qall, choiceType, totalStim] = sim_UCB_riskPref(params, dist, nIters);
end




plot_riskPref(choiceType, totalStim, Qall, model, dist, params);


end