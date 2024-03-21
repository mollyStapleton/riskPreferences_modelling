function plotSubjectFit(dataIn, paramFit, model, dist)

cd(['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\modelling_figures\model_fits\' model '\subjectLvl\' dist '\']);
% PLOT OF TRUE VS FIT: SINGLE SUBJECT
figure(1);
set(gcf, 'Position', [268.2000 69 1.2288e+03 648]);
if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    C = [colormap(cbrewer2('BuPu', 40))];
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    C =  [colormap(cbrewer2('YlGn', 40))];
end
col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};
CFit =  [colormap(cbrewer2('Greys', 40))];
%--------------------------------------------------------------------------
%%% PLOT P(RISKY) OVERALL: FIT VS TRUE
%------------------------------------------------------------------------------
h1 = axes('Position', [0.07 0.5 0.125 0.4]);
h2 = axes('Position', [0.22 0.5 0.125 0.4]);
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

    bar(1, [dataIn.meanTrue(icnd)], 'FaceColor', col2plot{icnd}, 'EdgeColor', col2plot{icnd});
    bar(2, [dataIn.meanFit(icnd)], 'FaceColor', col2plot_fit{icnd}, 'EdgeColor', col2plot_fit{icnd});
  
    xlim([0 3]);
    ylim([0 1]);
    hold on 
    plot([0 3], [0.5 0.5], 'k--');
    set(gca, 'XTick', [1 2]);
    set(gca, 'XTickLabel', {'\bfTrue', '\bfFit'});
    set(gca, 'XTickLabelRotation', 45);
    ylabel('P(Risky)');
    set(gca, 'FontName', 'Arial');
end

%--------------------------------------------------------------------------
%%% PLOT P(RISKY) TRIAL BINNED: FIT VS TRUE
%------------------------------------------------------------------------------
h3 = axes('Position', [0.07 0.05 0.125 0.4]);
h4 = axes('Position', [0.22 0.05 0.125 0.4]);
hold on

dataIn.binnedFit = cell2mat(dataIn.binnedFit); dataIn.binnedTrue = cell2mat(dataIn.binnedTrue);
for icnd = 1:2
    if icnd == 1
        axes(h3);
        hold on 
    else
        axes(h4);
        hold on        
    end

    plot(dataIn.binnedTrue(icnd, :), 'color', col2plot{icnd}, 'linew', 1.2);
    plot(dataIn.binnedFit(icnd, :), 'color', col2plot_fit{icnd}, 'linew', 1.2);
    plot(dataIn.binnedTrue(icnd, :), 'o', 'MarkerFaceColor', col2plot{icnd},...
        'MarkerEdgeColor', col2plot{icnd}, 'linew', 1.2);
    plot(dataIn.binnedFit(icnd, :), 'o', 'MarkerFaceColor', col2plot_fit{icnd},...
        'MarkerEdgeColor', col2plot_fit{icnd}, 'linew', 1.2);
    ylim([0 1]);
    hold on
    xlim([0 6]);
    plot([0 6], [0.5 0.5], 'k--');
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
h5 = axes('Position', [0.40 0.55 0.5 0.4]);
trueCol = C([10 20 30 40], :);
fitCol  = CFit([10 20 30 40], :);
trueX   = [0.5 2 3.5 5];
fitX    = [1 2.5 4 5.5];

for istim = 1:4
    hold on
    bar(trueX(istim), dataIn.accTrue(istim), 'FaceColor', trueCol(istim, :),...
        'EdgeColor', trueCol(istim, :), 'BarWidth', 0.5);
    bar(fitX(istim), dataIn.accFit(istim), 'FaceColor', [1 1 1],...
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

h6 = axes('Position', [0.3 0.05 0.4 0.4]);
dataIn.accTrue_binned = cell2mat(dataIn.accTrue_binned); dataIn.accFit_binned = cell2mat(dataIn.accFit_binned);
axis square
for istim = 1:4
    
    hold on
    plot(dataIn.accTrue_binned(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
    plot(dataIn.accTrue_binned(istim, :), 'o', 'MarkerFaceColor', C(istim*10, :),...
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
ylabel('P(High|Both-Different)');
xlabel('TrialBins');
title('\fontsize{12} \bf True Data');
set(gca, 'FontName', 'Arial');

h7 = axes('Position', [0.53 0.05 0.4 0.4]);
axis square
h = gca;
h.YAxis.Visible = 'off';
CFit =  [colormap(cbrewer2('Greys', 40))];
for istim = 1:4
    axes(h7)
    hold on
    plot(dataIn.accFit_binned(istim, :), '-',  'color', C(istim*10, :), 'linew', 1.5);
    plot(dataIn.accFit_binned(istim, :), 'o', 'MarkerFaceColor', [1 1 1],...
        'MarkerEdgeColor', C(istim*10, :), 'linew', 1.2);

end
ylabel('P(High|Both-Different)');
xlabel('TrialBins');
set(gca, 'FontName', 'Arial');
title('\fontsize{12} \bf Model Fit');
set(gca, 'FontSize', 8);
ylim([0 1]);
hold on
xlim([0 6]);
set(gca, 'XTick', [1:5]);
plot([0 6], [0.5 0.5], 'k--');

h8 = axes('Position', [0.87 0.05 0.1 0.4]);
axis square
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
set(gca, 'Visible', 'off')
end


