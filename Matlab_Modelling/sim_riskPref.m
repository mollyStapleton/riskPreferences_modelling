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
    [p_risky_t, p_high_t, Qall, PEIRS_all, Sall] = sim_PEIRS_riskPref(params, dist, nIters);
    plotSim_PEIRS_riskPref(p_risky_t, p_high_t, Qall, PEIRS_all, Sall, model, dist);
    txtTitle = {['\fontsize{11} Q0 = ' num2str(params.Q0) ', \fontsize{11} S0 = ' num2str(params.S0,'%.4f'),...
        ', \fontsize{11} \alphaQ = ' num2str(params.alphaQ,'%.4f') ', \fontsize{11} \alphaS = ' num2str(params.alphaS,'%.4f'),...
        ', \fontsize{10} \beta = ' num2str(params.beta,'%.4f') ', \fontsize{11} \omega = ' num2str(params.omega,'%.4f')]};
    sgtitle(txtTitle)

end


end