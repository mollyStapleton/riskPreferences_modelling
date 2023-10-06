function plotFit_RW_riskPref(dataIn, paramFit, dist)

if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    C = [colormap(cbrewer2('BuPu', 40))];
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    C =  [colormap(cbrewer2('YlGn', 40))];
end
    col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};
figure(1);
clf;
set(gcf, 'Position', [313 98.6000 1.2176e+03 663.4000]);

h1 = axes('Position', [0.05 0.35 0.4 0.4]);
axis square
hold on 
ba = boxchart([paramFit.alpha paramFit.beta], 'BoxFaceColor', col2plot{1});

ylabel('Fitted Parameter Values');
set(gca, 'XTickLabel', {'\alpha', '\beta'})
title('Descriptives');
set(gca, 'FontName', 'Arial');

h3 = axes('Position', [0.3 0.35 0.4 0.4]);
axis square
hold on
for icnd = 1:2
    if icnd == 1
        x2plot = [1 1.5];
    else
        x2plot = [2 2.5];
    end

    plot(x2plot(1), dataIn.meanTrue(:, icnd), 'o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', col2plot{icnd}, 'LineWidth', 1.2);
    hold on
    plot(x2plot(2), dataIn.meanFit(:, icnd), 'o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', col2plot_fit{icnd}, 'linew', 1.2);

end
axes(h3);
xlim([0.5 3]);
hold on 
plot([1.75 1.75], [ 0 1], 'k-');
plot([0.5 3], [0.5 0.5], 'k--');
set(gca, 'XTick', [1.25 2.25]);
set(gca, 'XTickLabel', {'LL', 'HH'});
title('Average P(Risky): True vs Model');
ylabel('Average P(Risky)');
set(gca, 'FontName', 'Arial');
h4 = axes('Position', [0.67 0.35 0.125 0.4]);
% axis square
h5 = axes('Position', [0.82 0.35 0.125 0.4]);
% axis square
hold on


for icnd = 1:2
    if icnd == 1
        axes(h4);
        hold on
    else
        axes(h5);
        hold on
    end

    mean2plot_true{icnd} = nanmean(cell2mat(dataIn.binnedTrue(:, icnd)));
    sem2plot_true{icnd}  = nanstd(cell2mat(dataIn.binnedTrue(:, icnd)))./sqrt(length(cell2mat(dataIn.binnedTrue(:, icnd))));
    errorbar(mean2plot_true{icnd}, sem2plot_true{icnd}, 'Color', col2plot{icnd}, 'LineWidth', 1.2);
    mean2plot_fit{icnd}  = nanmean(cell2mat(dataIn.binnedFit(:, icnd)));
    sem2plot_fit{icnd}  = nanstd(cell2mat(dataIn.binnedFit(:, icnd)))./sqrt(length(cell2mat(dataIn.binnedFit(:, icnd))));
    errorbar(mean2plot_fit{icnd}, sem2plot_fit{icnd}, 'Color', col2plot_fit{icnd}, 'LineWidth', 1.2);
    
 
end

axes(h4);
xlabel('Trial No.');
ylabel('P(Risky)');
title('Low-Low');
ylim([0 0.7]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
set(gca, 'FontName', 'Arial');
axes(h5);
xlabel('Trial No.');
ylabel('P(Risky)');
title('High-High');
ylim([0 0.7]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
set(gca, 'FontName', 'Arial');

sgTxt = [{'True Data vs RW Model Fits', 'Risk-Attitudes'}];
sgtitle(sgTxt, 'FontWeight', 'Bold', 'FontName', 'Arial');

figure(2);
h1 = subplot(1, 2, 1);
h2 = subplot(1, 2, 2);

stimHighIdx = {[31 13], [41 14], [32 23], [42 24]};
% 1: High-Safe|Low-Safe 
% 2: High-Risky|Low-Safe
% 3: High-Safe|Low-Risky
% 4: High-Risky|Low-Risky
% plot p(high) for the four unmatched conditions 
% TRUE data 

tmpData = cell2mat(dataIn.accTrue(1, :)');
for istim = 1:4
    
    stimData = [];
    stimData = tmpData([istim:4:end], :);
    
    meanTrue(istim, :) = nanmean(stimData);
    semTrue(istim, :)  = nanstd(stimData)./sqrt(length(stimData));


    axes(h1);
    axis square
    hold on
    errorbar(meanTrue(istim, :), semTrue(istim, :), 'color', C(istim*10, :), 'linew', 1.5);
end
ylim([0.2 1]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
xlabel('TrialBin');
ylabel('P(High)');
if strcmpi(dist, 'Gaussian')
    legend({'LLSafe-HHRisky', 'LLSafe-HHSafe', 'LLRisky-HHSafe', 'LLRisky-HHRisky', ''}, 'Location', 'SouthEast');
else 
    legend({'LLSafe-HHRisky', 'LLSafe-HHSafe', 'LLRisky-HHSafe', 'LLRisky-HHRisky', ''}, 'Location', 'NorthEast');
end
title('Accuracy: TRUE');
set(gca, 'FontName', 'Arial');
CFit =  [colormap(cbrewer2('Greys', 40))];
tmpData = cell2mat(dataIn.accFit(1, :)');
for istim = 1:4
    
    stimData = [];
    stimData = tmpData([istim:4:end], :);
    
    meanFit(istim, :) = nanmean(stimData);
    semFit(istim, :)  = nanstd(stimData)./sqrt(length(stimData));


    axes(h2);
    axis square
    hold on
    errorbar(meanFit(istim, :), semFit(istim, :), 'color', CFit(istim*10, :), 'linew', 1.5);
end
ylim([0.2 1]);
xlim([0 6]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
xlabel('TrialBin');
ylabel('P(High)');
legend({'LLSafe-HHRisky', 'LLSafe-HHSafe', 'LLRisky-HHSafe', 'LLRisky-HHRisky', ''}, 'Location', 'NorthEast');
title('Accuracy: FIT');
set(gca, 'FontName', 'Arial');
end