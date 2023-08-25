function plot_riskPref(choiceType, totalStim, model, dist, params)

    if strcmp(dist, 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    else 
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    end

    [all, binned] = calculate_riskPref(choiceType, totalStim);

    figure(1);
    h1 = subplot(1, 2, 1);
    h2 = subplot(1, 2, 2);
    for ichoice = 1:2
        
        
        axes(h1);
        hold on 
        plot([1:120], all{ichoice}, 'color', col2plot{ichoice}, 'linew', 1.2);

        axes(h2);
        hold on
        errorbar(binned{1, ichoice}, binned{2, ichoice}, 'color', col2plot{ichoice}, 'linew', 2);
    

    end

    axes(h1);
    axis square
    hold on 
    xlim([0 120])
    plot([0 120], [0.5 0.5], 'k--');
    xlabel('TrialNumber');
    ylabel('P(Risky)');
    set(gca, 'FontSize', 14);
    set(gca, 'FontName', 'Arial');
    axes(h2);
    axis square
    xlim([0 6]);
    ylim([0 1]);
    hold on
    plot([0 6], [0.5 0.5], 'k--');
    ylabel('P(Risky)');
    xlabel('TrialsBinned');
    set(gca, 'FontSize', 14);
    set(gca, 'FontName', 'Arial');
   
    titleText = [{['Model: ' model]}, {['\alpha = ' num2str(params.alpha) '\beta = ' num2str(params.beta)]}];
    sgtitle(titleText)
end
