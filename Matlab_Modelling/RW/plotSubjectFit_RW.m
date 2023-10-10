function plotSubjectFit_RW(binnedTrue, binnedFit, accTrue, accFit, dist)

    % PLOT OF TRUE VS FIT: SINGLE SUBJECT
    figure(1);
    set(gcf, 'Position', [488 285.8000 1.0162e+03 476.2000]);
    if strcmp(dist, 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
        C = [colormap(cbrewer2('BuPu', 40))];
    else
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
        C =  [colormap(cbrewer2('YlGn', 40))];
    end
    col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};

    % PLOT RISK PREFERENCE: FIT VS TRUE
    h1 = axes('Position', [0.07 0.35 0.125 0.4]);
%     axis square
    h2 = axes('Position', [0.22 0.35 0.125 0.4]);
%     axis square
    hold on

    for icnd = 1:2
        if icnd == 1
            axes(h1);
            hold on
        else
            axes(h2);
            hold on
        end

        plot(binnedTrue{icnd}, 'color', col2plot{icnd}, 'linew', 1.2);
        plot(binnedFit{icnd}, 'color', col2plot_fit{icnd}, 'linew', 1.2);
        plot(binnedTrue{icnd}, 'o', 'MarkerFaceColor', col2plot{icnd},...
            'MarkerEdgeColor', col2plot{icnd}, 'linew', 1.2);
        plot(binnedFit{icnd}, 'o', 'MarkerFaceColor', col2plot_fit{icnd},...
            'MarkerEdgeColor', col2plot_fit{icnd}, 'linew', 1.2);
        ylim([0 1]);
        hold on 
        xlim([0 6]);
        plot([0 6], [0.5 0.5], 'k--');
    end

    axes(h1);
    ylabel('P(Risky)');
    xlabel('TrialBin');
    title('\bf \fontsize{12} Low-Low');
    set(gca, 'FontName', 'Arial');
    axes(h2);
    xlabel('TrialBin');
    h = gca;
    h.YAxis.Visible = 'off';
    title('\bf \fontsize{12} High-High');
    set(gca, 'FontName', 'Arial');
    h3 = axes('Position', [0.37 0.35 0.4 0.4]);
    axis square
    for istim = 1:4
        axes(h3)
        hold on
        plot(accTrue(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
        plot(accTrue(istim, :), 'o', 'MarkerFaceColor', C(istim*10, :),...
            'MarkerEdgeColor', C(istim*10, :), 'linew', 1.2);

    end
    ylim([0 1]);
    hold on
    xlim([0 6]);
    plot([0 6], [0.5 0.5], 'k--');
    if strcmpi(dist, 'Gaussian')
        legend({'LLSafe-HHRisky', '', 'LLSafe-HHSafe', '', 'LLRisky-HHSafe', '', 'LLRisky-HHRisky', '', ''},...
            'Position', [0.5 0.05 0.15 0.15]);
    else
        legend({'LLSafe-HHRisky', '', 'LLSafe-HHSafe', '', 'LLRisky-HHSafe', '', 'LLRisky-HHRisky', '', ''},...
            'Position', [0.5 0.05 0.15 0.15]);
    end
    ylabel('P(High|Both-Different)');
    xlabel('TrialBins');
    title('\bf \fontsize{12} Accuracy: TRUE');
    set(gca, 'FontName', 'Arial');
    h4 = axes('Position', [0.62 0.35 0.4 0.4]);
    axis square
    CFit =  [colormap(cbrewer2('Greys', 40))];
    for istim = 1:4
        axes(h4)
        hold on
        plot(accFit(istim, :), '--',  'color', C(istim*10, :), 'linew', 1.5);
        plot(accFit(istim, :), 'o', 'MarkerFaceColor', C(istim*10, :),...
            'MarkerEdgeColor', C(istim*10, :), 'linew', 1.2);

    end
    ylabel('P(High|Both-Different)');
    xlabel('TrialBins');
    title('\bf \fontsize{12} Accuracy: FIT');
    set(gca, 'FontName', 'Arial');
    ylim([0 1]);
    hold on
    xlim([0 6]);
    plot([0 6], [0.5 0.5], 'k--');
    if strcmpi(dist, 'Gaussian')
        legend({'LLSafe-HHRisky', '', 'LLSafe-HHSafe', '', 'LLRisky-HHSafe', '', 'LLRisky-HHRisky', '', ''},...
            'Position', [0.75 0.05 0.15 0.15]);
    else
        legend({'LLSafe-HHRisky', '', 'LLSafe-HHSafe', '', 'LLRisky-HHSafe', '', 'LLRisky-HHRisky', '', ''},...
            'Position', [0.75 0.05 0.15 0.15]);
    end
    

end


