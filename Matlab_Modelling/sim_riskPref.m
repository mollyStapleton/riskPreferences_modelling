function sim_riskPref(model, params, dist, nIters)

if strcmpi(model, 'RW')
     [p_risky_t, p_high_t, Qall] = sim_RW_riskPref(params, dist, nIters);
     plotSim_riskPref(p_risky_t, p_high_t, Qall, model, dist);
     txtTitle = {['\fontsize{14} \alpha = ' num2str(params.alpha) '\fontsize{14} \beta = ' num2str(params.beta)]};
     sgtitle(txtTitle);     
end

if strcmpi(model, 'RATES')
    [p_risky_t, p_high_t, Qall] = sim_RATES_riskPref(params, dist, nIters);
    plotSim_riskPref(p_risky_t, p_high_t, Qall, model, dist);
   
end

if strcmpi(model, 'UCB_nCount')
    [p_risky_t, p_high_t, Qall, UCB_all] = sim_UCB_nCount_riskPref(params, dist, nIters);
    plotSim_UCB_nCounts_riskPref(p_risky_t, p_high_t, Qall, UCB_all, model, dist);
end

if strcmpi(model, 'UCB_spread')
    [p_risky_t, p_high_t, Qall, UCB_all, Sall] = sim_UCB_spread_riskPref(params, dist, nIters);
    plotSim_UCB_spread_riskPref(p_risky_t, p_high_t, Qall, UCB_all, Sall, model, dist);
end

if strcmpi(model, 'PEIRS')
    [Qall, Sall, choiceType, totalStim] = sim_PEIRS_riskPref(params, dist, nIters);
    plot_riskPref(choiceType, totalStim, Qall, Sall, model, dist, params);
end






end