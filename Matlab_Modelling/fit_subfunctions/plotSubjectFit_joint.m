function plotSubjectFit_joint(dataIn, paramFit, model, dist)

cd(['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\modelling_figures\model_fits\' model '\subjectLvl\' dist '\']);
% PLOT OF TRUE VS FIT: SINGLE SUBJECT

figure(1);
set(gcf, 'Position', [12.2000 45 1.4112e+03 736]);
h1 = axes('Position', [0.03 0.5 0.125 0.4]);
h2 = axes('Position', [0.18 0.5 0.125 0.4]);
h3 = axes('Position', [0.03 0.05 0.125 0.4]);
h4 = axes('Position', [0.18 0.05 0.125 0.4]);

for idist = 1:2
    if idist == 1
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
        C = [colormap(cbrewer2('BuPu', 40))];
        x2plot = [1 1.5]

    else
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
        C =  [colormap(cbrewer2('YlGn', 40))];
        x2plot = [2.5 3];
    end


    %--------------------------------------------------------------------------
    %%% PLOT P(RISKY) OVERALL: FIT VS TRUE
    %------------------------------------------------------------------------------
    hold on
    for icnd = 1:2
        if icnd == 1
            axes(h1);
            hold on
            title({'\bf \fontsize{14}                              Risk Preferences',...
                '\fontsize{10} Low-Low'});
        else
            axes(h2);
            hold on
            title('\bf \fontsize{10} High-High');
            h = gca;
            h.YAxis.Visible = 'off';
        end

        bar(x2plot(1), [dataIn.meanTrue(idist, icnd)], 'FaceColor', col2plot{icnd}, 'EdgeColor', col2plot{icnd}, 'BarWidth', 0.5);
        bar(x2plot(2), [dataIn.meanFit(idist, icnd)], 'FaceColor', [1 1 1], 'EdgeColor', col2plot{icnd}, 'BarWidth', 0.5, 'LineWidth', 2);

        xlim([0 4]);
        ylim([0 1]);
        hold on
        plot([0 4], [0.5 0.5], 'k--');
        set(gca, 'XTick', [1 1.5 2.5 3]);
        set(gca, 'XTickLabel', {'\bfTrue', '\bfFit' '\bfTrue', '\bfFit'});
        set(gca, 'XTickLabelRotation', 45);
        ylabel('P(Risky)');
        set(gca, 'FontName', 'Arial');
        
    end

    %--------------------------------------------------------------------------
    %%% PLOT P(RISKY) TRIAL BINNED: FIT VS TRUE
    %------------------------------------------------------------------------------

    hold on
    for icnd = 1:2
        if icnd == 1
            axes(h3);
            hold on
        else
            axes(h4);
            hold on
        end

        plot(dataIn.binnedTrue{idist}(icnd, :), 'color', col2plot{icnd}, 'linew', 1.2);
        plot(dataIn.binnedFit{idist}(icnd, :), 'color', col2plot{icnd}, 'linew', 1.2);
        plot(dataIn.binnedTrue{idist}(icnd, :), 'o', 'MarkerFaceColor', col2plot{icnd},...
            'MarkerEdgeColor', col2plot{icnd}, 'linew', 1.2);
        plot(dataIn.binnedFit{idist}(icnd, :), 'o', 'MarkerFaceColor', [1 1 1],...
            'MarkerEdgeColor', col2plot{icnd}, 'linew', 1.2);
        ylim([0 1]);
        hold on
        xlim([0 6]);
        plot([0 6], [0.5 0.5], 'k--');

        if idist == 2
            legend({'', '', 'True', 'Fit', '', '', '', 'True', 'Fit', ''})
        end
    end

    axes(h3);
    ylabel('P(Risky)');
    xlabel('TrialBin');
    set(gca, 'FontName', 'Arial');
    axes(h4);
    xlabel('TrialBin');
    h = gca;
    h.YAxis.Visible = 'off';
    set(gca, 'FontName', 'Arial');


    %--------------------------------------------------------------------------
    %%% PLOT P(HIGH) OVERALL: FIT VS TRUE
    %------------------------------------------------------------------------------
    if idist == 1
        h5 = axes('Position', [0.35 0.55 0.25 0.4]);
    else
        h6 = axes('Position', [0.63 0.55 0.25 0.4]);
    end

    trueCol = C([10 20 30 40], :);
    trueX   = [0.5 2 3.5 5];
    fitX    = [1 2.5 4 5.5];

    for istim = 1:4
        hold on
        bar(trueX(istim), dataIn.accTrue(idist, istim), 'FaceColor', trueCol(istim, :),...
            'EdgeColor', trueCol(istim, :), 'BarWidth', 0.5);
        bar(fitX(istim), dataIn.accFit(idist, istim), 'FaceColor', [1 1 1],...
            'EdgeColor', trueCol(istim, :), 'linew', 1.5, 'BarWidth', 0.5);

    end
    set(gca, 'XTick', [0.5:0.5:5.5]);
    set(gca, 'XTickLabel', {'\bfTrue', '\bfFit', '', '\bfTrue', '\bfFit', '',...
        '\bfTrue', '\bfFit', '', '\bfTrue', '\bfFit', ''});
    set(gca, 'XTickLabelRotation', 45);
    ylabel('P(High|Both-Different)');
    title('\fontsize{14} \bf Accuracy')
    hold on

    xlim([-0.5 6.5])
    plot([-0.5 6.5], [0.5 0.5], 'k--');
    legend({'HHSafe-LLSafe', '', 'HHSafe-LLRisky', '', 'HHRisky-LLSafe', '', 'HHRisky-LLRisky', '', ''},...
        'Location', 'northwest')
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', 8);

    %--------------------------------------------------------------------------
    %%% PLOT P(HIGH) TRIAL BINNED: FIT VS TRUE
    %------------------------------------------------------------------------------
    if idist == 1 
        h7 = axes('Position', [0.35 0.28 0.25 0.2])
    else 
        h9 = axes('Position', [0.63 0.28 0.25 0.2])
    end
    
    
    for istim = 1:4
        
        hold on
        plot(dataIn.accTrue_binned{idist}(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
        plot(dataIn.accTrue_binned{idist}(istim, :), 'o', 'MarkerFaceColor', C(istim*10, :),...
            'MarkerEdgeColor', C(istim*10, :), 'linew', 1.2);
    end
    ylim([0 1]);
    hold on
    set(gca, 'FontSize', 8);
    xlim([0 6]);
    set(gca, 'XTick', [1:5]);
    plot([0 6], [0.5 0.5], 'k--');
    % if strcmpi(dist, 'Gaussian')
    %     legend({'HHSafe-LLSafe', '', 'HHSafe-LLRisky', '', 'HHRisky-LLSafe', '', 'HHRisky-LLRisky', '', ''},...
    %         'Position', [0.5 0.05 0.15 0.15]);
    % else
    %     legend({'HHSafe-LLSafe', '', 'HHSafe-LLRisky', '', 'HHRisky-LLSafe', '', 'HHRisky-LLRisky', '', ''},...
    %         'Position', [0.5 0.05 0.15 0.15]);
    % end
    ylabel({'\bfTrue Data', '\rm(High|Both-Different)'});
    xlabel('TrialBins');
    set(gca, 'FontName', 'Arial');
    if idist == 1 
        h8 = axes('Position', [0.35 0.05 0.25 0.2]);
    else 
        h10 = axes('Position', [0.63 0.05 0.25 0.2]);
    end
    for istim = 1:4
        hold on
        plot(dataIn.accFit_binned{idist}(istim, :), '-',  'color', C(istim*10, :), 'linew', 1.5);
        plot(dataIn.accFit_binned{idist}(istim, :), 'o', 'MarkerFaceColor', [1 1 1],...
            'MarkerEdgeColor', C(istim*10, :), 'linew', 1.2);
    end
    ylabel({'\bfModel Fit', '\rm(High|Both-Different)'});
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', 8);
    ylim([0 1]);
    hold on
    xlim([0 6]);
    set(gca, 'XTick', [1:5]);
    plot([0 6], [0.5 0.5], 'k--');

end
axParam = axes('position', [0.87 0.45 0.15 0.15])
axis square
axParam
if strcmpi(model, 'RW')
    txtPlot = {['SubjectIdx: ' num2str(paramFit.ptIdx) ], ['\alpha = ' num2str(paramFit.fittedParams(1), '%.4f')], ['\beta = ' num2str(paramFit.fittedParams(2), '%.4f')],...
        ['LL = ' num2str(paramFit.LL, '%.2f')], ['BIC = ' num2str(paramFit.BIC, '%.2f')]};
elseif strcmpi(model, 'RATES')
    txtPlot = {['SubjectIdx: ' num2str(paramFit.ptIdx) ], ['\alphaPos = ',  num2str(paramFit.fittedParams(1), '%.4f') ],...
        ['\alphaNeg = '  num2str(paramFit.fittedParams(2), '%.4f') ], ['\beta = ' num2str(paramFit.fittedParams(3), '%.4f') ],...
        ['LL = ' num2str(paramFit.LL, '%.2f') ], ['BIC = ' num2str(paramFit.BIC, '%.2f') ]};
elseif strcmpi(model, 'UCB_nCount')
    txtPlot = {['SubjectIdx: ' num2str(paramFit.ptIdx) ], ['\alpha = ',  num2str(paramFit.fittedParams(1), '%.4f') ],...
        ['\beta = '  num2str(paramFit.fittedParams(2), '%.4f') ], ['c = ' num2str(paramFit.fittedParams(3), '%.4f') ],...
        ['LL = ' num2str(paramFit.LL, '%.2f') ], ['BIC = ' num2str(paramFit.BIC, '%.2f') ]};
elseif strcmpi(model, 'UCB_spread')
    txtPlot = {['SubjectIdx: ' num2str(paramFit.ptIdx) ], ['\alphaQ = ',  num2str(paramFit.fittedParams(1), '%.2f') ],...
        ['\alphaS = ',  num2str(paramFit.fittedParams(2), '%.2f') ], ['\beta = '  num2str(paramFit.fittedParams(3), '%.2f') ],...
        ['c = ' num2str(paramFit.fittedParams(4), '%.2f') ], ['S0 = ' num2str(paramFit.fittedParams(5), '%.2f')],...
        ['LL = ' num2str(paramFit.LL, '%.2f') ], ['BIC = ' num2str(paramFit.BIC, '%.2f') ]};
elseif strcmpi(model, 'PEIRS')
    txtPlot = {['SubjectIdx: ' num2str(paramFit.ptIdx) ], ['\alphaQ = ',  num2str(paramFit.fittedParams(1), '%.2f') ],...
        ['\alphaS = ',  num2str(paramFit.fittedParams(2), '%.2f') ], ['\beta = '  num2str(paramFit.fittedParams(3), '%.2f') ],...
        ['S0 = ' num2str(paramFit.fittedParams(5), '%.2f')], ['\omega = ' num2str(paramFit.fittedParams(4), '%.2f') ],...
        ['LL = ' num2str(paramFit.LL, '%.2f') ], ['BIC = ' num2str(paramFit.BIC, '%.2f') ]};
end

text(0, 0.55, txtPlot, 'FontSize', 12, 'FontName', 'Arial');
set(gca, 'Visible', 'off');

end
