function paramPredict_RW_riskPref(params, dist, nIters)

figure(1);
h1 = subplot(2, 2, 1); 
h2 = subplot(2, 2, 2); 
h3 = subplot(2, 2, 3);
h4 = subplot(2, 2, 4);

for idist = 1: length(dist)
    countalpha = 0; countbeta = 0;
    for ialpha = params.alpha
        countalpha = countalpha + 1;
        countbeta  = 0;
    
        for ibeta = params.beta
            countbeta  = countbeta + 1;
            params2run.alpha = ialpha;
            params2run.beta  = ibeta;

            params2run.Q0    = 0;
%             [Qall{countalpha, countbeta}, choiceType{countalpha, countbeta}, totalStim{countalpha, countbeta},...
%                 meanAcc{countalpha, countbeta}] = sim_RW_riskPref(params2run, dist{idist}, nIters);
            [p_risky_t{countalpha, countbeta}, p_high_t{countalpha, countbeta},...
                ~] = sim_RW_riskPref(params2run, dist{idist}, nIters);
           
            for icnd = 1:2
                mean2plot_risk{idist, icnd}(countalpha, countbeta) = nanmean(p_risky_t{countalpha, countbeta}(icnd,:));
            end
            
            for istim = 1:4
                accPlot{istim}(countalpha, countbeta) = nanmean(p_high_t{countalpha, countbeta}(istim, :));
            end

        end
    end
end
C = colormap(flipud(cbrewer2('RdBu')));
% caxis([0 0.5]);
for idist = 1:2
    for itype = 1:2
        if idist == 1
            avgParam_alpha = 0.2956;
            avgParam_beta  = 0.2996;
            if itype == 1
                axes(h1);
                axis square
            else
                axes(h2);
                axis square
            end
        else
            avgParam_alpha = 0.3323;
            avgParam_beta  = 0.2220;
            if itype == 1
                axes(h3);
                axis square
            else
                axes(h4);
                axis square
            end
        end
            hold on
            imagesc(mean2plot_risk{idist, itype});
            set(gca,'Ydir','normal');
            set(gca, 'YTick', [1:4:length(params.alpha)]);
            set(gca, 'XTick', [1:4:length(params.beta)]);
            set(gca, 'XLim', [1 length(params.beta)]);
            set(gca, 'YLim', [1 length(params.alpha)]);
            set(gca, 'YTickLabel', round(params.alpha(1:4:end), 2));
            xlabel('\fontsize{12} \bf \beta');
            ylabel('\fontsize{12} \bf \alpha');
            set(gca, 'XTickLabel', round(params.beta(1:4:end), 2));
            set(gca, 'XTickLabelRotation', 45)
            if itype == 1
                ttext = [{dist{idist},' P(Risky): LL'}];
            else
                ttext = [{dist{idist},' P(Risky): HH'}];
            end
            title(ttext, 'FontWeight', 'bold', 'FontSize', 12);
            set(gca, 'FontName', 'Arial');
            caxis([0.5 - (1 - 0.5), 0.5 + (0.5 - 0)]);
            hold on 
            y_position = find(params.alpha >= avgParam_alpha, 1, 'first'); % x-coordinate of the square's top-left corner
            x_position = find(params.beta >= avgParam_beta, 1, 'first'); % y-coordinate of the square's top-left corner
            width = 1;     % Width of the square
            height = 1;    % Height of the square
            hold on 
            rectangle('Position', [x_position, y_position, width, height], 'EdgeColor', 'k', 'LineWidth', 2);
    end
end

gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
C1.Limits   = [0 1];
set(gcf, 'Position', [505 51.4000 816 731.2000]);


% % generate accuracy prediction plots, for each of the four unmatched
% % conditions
figure(2);
C = colormap(flipud(cbrewer2('RdBu')));
titletext = {'HHSafe-LLSafe', 'HHSafe-LLRisky', 'HHRisky-LLSafe','HHRisky-LLRisky'};
for istim = 1:4
    subplot(2, 2, istim)
    hold on
    imagesc(accPlot{istim});
    set(gca,'Ydir','normal');
    set(gca, 'YTick', [1:4:length(params.alpha)]);
    set(gca, 'XTick', [1:4:length(params.beta)]);
    set(gca, 'XLim', [1 length(params.beta)]);
    set(gca, 'YLim', [1 length(params.alpha)]);
    set(gca, 'YTickLabel', round(params.alpha(1:4:end), 2));
    xlabel('\fontsize{12} \bf \beta');
    ylabel('\fontsize{12} \bf \alpha');
    set(gca, 'XTickLabel', round(params.beta(1:4:end), 2));
    set(gca, 'XTickLabelRotation', 45);
    title(titletext{istim}, 'FontWeight', 'bold', 'FontSize', 12);
    set(gca, 'FontName', 'Arial');
    caxis([0 1]);
    hold on
    y_position = find(params.alpha >= avgParam_alpha, 1, 'first'); % x-coordinate of the square's top-left corner
    x_position = find(params.beta >= avgParam_beta, 1, 'first'); % y-coordinate of the square's top-left corner
    width = 1;     % Width of the square
    height = 1;    % Height of the square
    hold on
    rectangle('Position', [x_position, y_position, width, height], 'EdgeColor', 'k', 'LineWidth', 2);

end
gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
C1.Limits   = [0 1];
set(gcf, 'Position', [505 51.4000 816 731.2000]);

end