function plotFit_riskPref(dataIn, paramFit, model, dist)

if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    C = [colormap(cbrewer2('BuPu', 40))];
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    C =  [colormap(cbrewer2('YlGn', 40))];
end
col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};
CFit =  [colormap(cbrewer2('Greys', 40))];
figure(1);
clf;
% set(gcf, 'Position', [2.0226e+03 -50.2000 1.4568e+03 728]);
set(gcf, 'Position', [-11.8000 20.2000 1.5344e+03 750.4000]);
h1 = axes('Position', [0.001 0.35 0.4 0.4]);
axis square
hold on 
if strcmpi(model, 'RW')
    ba = boxchart([paramFit.alpha paramFit.beta], 'BoxFaceColor', col2plot{1});
    set(gca, 'XTickLabel', {'\alpha', '\beta'})
elseif strcmpi(model, 'RATES')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', col2plot{1});
    set(gca, 'XTickLabel', {'\alphaPos', '\alphaNeg', '\beta'})
end

ylabel('Fitted Parameter Values');
title('Descriptives');
set(gca, 'FontName', 'Arial');

%--------------------------------------------------------------------------
%%% PLOT P(RISKY) OVERALL: FIT VS TRUE
%------------------------------------------------------------------------------
h2 = axes('Position', [0.33 0.52 0.125 0.4]);
h3 = axes('Position', [0.47 0.52 0.125 0.4]);
hold on

for icnd = 1:2
    if icnd == 1
        axes(h2);
        hold on
        title({'\bf \fontsize{14}                                             Risk Preferences',...
            '\fontsize{10} Low-Low'});
    else
        axes(h3);
        hold on
        title('\bf \fontsize{10} High-High');
        h = gca;
        h.YAxis.Visible = 'off';
    end

    for itype = 1:2 
        if itype == 1 
            meanData = cell2mat(dataIn.meanTrue);
            colPlot  = col2plot;
        else 
            meanData = cell2mat(dataIn.meanFit);
            colPlot  = col2plot_fit;
        end

            mean2plot(itype, icnd) = nanmean(meanData(:, icnd));
            sem2plot(itype, icnd)  = nanstd(meanData(:, icnd))./sqrt(length(meanData(:, icnd)));
        
            hold on 
            [hb, hberr] = barwitherr(sem2plot(itype, icnd), mean2plot(itype, icnd), 'FaceColor',...
                colPlot{icnd}, 'EdgeColor', colPlot{icnd});
            hb.XData = itype;
            hberr.XData = itype;
    end
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
h4 = axes('Position', [0.33 0.06 0.125 0.4]);
h5 = axes('Position', [0.47 0.06 0.125 0.4]);
hold on

for icnd = 1:2
    if icnd == 1
        axes(h4);
        hold on
    else
        axes(h5);
        h = gca;
        h.YAxis.Visible = 'off';
        hold on
    end
    tmp                  = [];
    tmp                  = cell2mat([dataIn.binnedTrue]);
    mean2plot_true{icnd} = nanmean(tmp(icnd: 2: end, :));
    sem2plot_true{icnd}  = nanstd(tmp(icnd: 2: end, :))./sqrt(length(tmp(icnd: 2: end, :)));
    errorbar(mean2plot_true{icnd}, sem2plot_true{icnd}, 'Color', col2plot{icnd}, 'LineWidth', 1.2);
    tmp                  = [];
    tmp                  = cell2mat([dataIn.binnedFit]);
    mean2plot_fit{icnd}  = nanmean(tmp(icnd: 2: end, :));
    sem2plot_fit{icnd}   = nanstd(tmp(icnd: 2: end, :))./sqrt(length(tmp(icnd: 2: end, :)));
    errorbar(mean2plot_fit{icnd}, sem2plot_fit{icnd}, 'Color', col2plot_fit{icnd}, 'LineWidth', 1.2);

end

axes(h4);
xlabel('Trial No.');
ylabel('P(Risky)');
ylim([0 0.7]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
legend({'True', 'Fit', ''}, 'Location', 'southwest')
set(gca, 'FontName', 'Arial');
axes(h5);
xlabel('Trial No.');
ylabel('P(Risky)');
ylim([0 0.7]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
legend({'True', 'Fit', ''}, 'Location', 'southwest')
set(gca, 'FontName', 'Arial');

%--------------------------------------------------------------------------
%%% PLOT P(HIGH) OVERALL: FIT VS TRUE
%------------------------------------------------------------------------------
h6 = axes('Position', [0.64 0.55 0.33 0.4]);
trueCol = C([10 20 30 40], :);
trueX   = [0.5 2 3.5 5];
fitX    = [1 2.5 4 5.5];

for istim = 1:4
    for itype = 1:2
        if itype == 1
            tmpData = cell2mat([dataIn.meanAccTrue]);
            colFil   = trueCol;
            x2plot = trueX;
        else
            tmpData = cell2mat([dataIn.meanAccFit]);
            colFil   = [1 1 1; 1 1 1; 1 1 1; 1 1 1];
            x2plot = fitX;
        end

        mean2plot(itype, istim) = nanmean(tmpData(:, istim));
        sem2plot(itype, istim)  = nanstd(tmpData(:, istim))./sqrt(length(tmpData(:, istim)));
        hold on
        [hb, hberr] = barwitherr(sem2plot(itype, istim), mean2plot(itype, istim), 'FaceColor',...
            colFil(istim, :), 'EdgeColor', trueCol(istim, :), 'BarWidth', 0.5);
        hb.XData = x2plot(istim);
        hberr.XData = x2plot(istim);
        hb.BarWidth = 0.4;
        hb.LineWidth = 1.5;

    end
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
legend({'HHSafe-LLSafe', '', '', '', 'HHSafe-LLRisky', '', '', '', 'HHRisky-LLSafe',...
     '', '', '', 'HHRisky-LLRisky',  '', '', '',},...
    'Location', 'northwest')
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 8);

%--------------------------------------------------------------------------
%%% PLOT P(HIGH) TRIAL BINNED: FIT VS TRUE
%------------------------------------------------------------------------------
h7 = axes('Position', [0.64 0.06 0.15 0.4]); 
tmpData = cell2mat(dataIn.accTrue_binned);
for istim = 1:4
    
    stimData = [];
    stimData = tmpData([istim:4:end], :);
    
    meanTrue(istim, :) = nanmean(stimData);
    semTrue(istim, :)  = nanstd(stimData)./sqrt(length(stimData));
  
    axis square
    hold on
    errorbar(meanTrue(istim, :), semTrue(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
    plot([1:5], meanTrue(istim, :), 'o', 'MarkerEdgeColor',...
        C(istim*10, :), 'MarkerFaceColor', C(istim*10, :), 'linew', 1.2);
end
ylim([0.2 1]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
xlabel('TrialBin');
ylabel('P(High)');
title('\fontsize{10} \bfTrue Data');
set(gca, 'FontName', 'Arial');

h8 = axes('Position', [0.82 0.06 0.15 0.4]); 
CFit =  [colormap(cbrewer2('Greys', 40))];
tmpData = cell2mat(dataIn.accFit_binned);
for istim = 1:4
    
    stimData = [];
    stimData = tmpData([istim:4:end], :);
    
    meanFit(istim, :) = nanmean(stimData);
    semFit(istim, :)  = nanstd(stimData)./sqrt(length(stimData));
    axis square
    hold on
    errorbar(meanFit(istim, :), semFit(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
    plot([1:5], meanFit(istim, :), 'o', 'MarkerEdgeColor',...
        C(istim*10, :), 'MarkerFaceColor', [1 1 1], 'linew', 1.2);
end
ylim([0.2 1]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
xlabel('TrialBin');
ylabel('P(High)');
title('\fontsize{10} \bfModel Fit');
set(gca, 'FontName', 'Arial');


end