function parPredict_riskPref(model, params, dist, nIters)


if strcmpi(model, 'RW')
        paramPredict_RW_riskPref(params, dist, nIters);
end
if strcmpi(model, 'RATES')
        paramPredict_RATES_riskPref(params, dist, nIters);
end
if strcmpi(model, 'UCB_nCount')
        paramPredict_UCB_nCount_riskPref(params, dist, nIters);
end
if strcmpi(model, 'UCB_spread')
        paramPredict_UCB_spread_riskPref(params, dist, nIters);
end
% if strcmpi(model, 'RATES')
%     [Qall, choiceType, totalStim] = sim_RATES_riskPref(params, dist, nIters);
%     plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
% end
% if strcmpi(model, 'UCB')
%     [Qall, choiceType, totalStim] = sim_UCB_riskPref(params, dist, nIters);
%     plot_riskPref(choiceType, totalStim, Qall, [], model, dist, params);
% end
% if strcmpi(model, 'PEIRS')
%     [Qall, Sall, choiceType, totalStim] = sim_PEIRS_riskPref(params, dist, nIters);
%     plot_riskPref(choiceType, totalStim, Qall, Sall, model, dist, params);
% end

end
