function plot_riskPref(choiceType, totalStim, Qall, model, dist, params)

    if strcmp(dist, 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    else 
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    end

    [all, binned] = calculate_riskPref(choiceType, totalStim);

    figure(1);
    h1 = subplot(1, 3, 1);
    h2 = subplot(1, 3, 2);
    h3 = subplot(1, 3, 3);

    for istim = 1:4
        mean2plot{istim} = nanmean(Qall{istim});
        sem2plot{istim}  = nanstd(Qall{istim})./sqrt(length((Qall{istim})));
        axes(h1);
        hold on 
        if (istim == 1 || istim == 3) %safe stimuli 
            lin2plot = '--';
        else 
            lin2plot = '-';
        end
        if (istim == 1 | istim == 2)
            plot([1:120], mean2plot{istim}, 'color', col2plot{1}, 'lineStyle', lin2plot, 'LineWidth', 1.2);
        else
            plot([1:120], mean2plot{istim}, 'color', col2plot{2}, 'lineStyle', lin2plot, 'LineWidth', 1.2);
        end

    end

    for ichoice = 1:2
   
        axes(h2);
        hold on 
        plot([1:120], all{ichoice}, 'color', col2plot{ichoice}, 'linew', 1.2);

        axes(h3);
        hold on
        errorbar(binned{1, ichoice}, binned{2, ichoice}, 'color', col2plot{ichoice}, 'linew', 2);

    end

    axes(h1);
    axis square
    hold on 
    xlim([0 120])
    title('Qvalue');
    ylabel('Average Estimate Q');
    xlabel('TrialNumber');
    set(gca, 'FontSize', 14);
    set(gca, 'FontName', 'Arial');
    axes(h2);
    axis square
    hold on 
    xlim([0 120])
    plot([0 120], [0.5 0.5], 'k--');
    ylim([0 1]);
    title('Risk Preferences')
    xlabel('TrialNumber');
    ylabel('P(Risky)');
    set(gca, 'FontSize', 14);
    set(gca, 'FontName', 'Arial');
    axes(h3);
    axis square
    xlim([0 6]);
    ylim([0 1]);
    hold on
    plot([0 6], [0.5 0.5], 'k--');
    ylabel('P(Risky)');
    title('Risk Preferences Binned')
    xlabel('TrialsBinned');
    set(gca, 'FontSize', 14);
    set(gca, 'FontName', 'Arial');
   
    if strcmpi(model, 'RW')
        titleText = [{['Model: ' model]}, {['\alpha = ' num2str(params.alpha) ' \beta = ' num2str(params.beta)]}];
    elseif strcmpi(model, 'RATES')
        titleText = [{['Model: ' model]}, {['\alphaPOS = ' num2str(params.alpha_pos),...
            ' \alphaNEG = ' num2str(params.alpha_neg) ' \beta = ' num2str(params.beta)]}];
    elseif strcmpi(model, 'UCB')
          titleText = [{['Model: ' model]}, {[' c = ' num2str(params.c) ' \beta = ' num2str(params.beta)]}];
    end

    sgtitle(titleText)
end
