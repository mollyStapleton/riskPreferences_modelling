function sim_riskPref(model, params, dist, nIters)

if strcmpi(model, 'RW')
    [Qall, choiceType, totalStim] = sim_RW_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
end
if strcmpi(model, 'RATES')
    [Qall, choiceType, totalStim] = sim_RATES_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
end
if strcmpi(model, 'UCB_nCount')
    [Qall, choiceType, totalStim] = sim_UCB_nCount_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
end
if strcmpi(model, 'UCB_spread')
    [Qall, choiceType, totalStim] = sim_UCB_spread_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
end
if strcmpi(model, 'PEIRS')
    [Qall, Sall, choiceType, totalStim] = sim_PEIRS_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, Sall, model, dist, params);
end






end