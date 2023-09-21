function plotFit_RW_riskPref(dataIn, paramFit, dist)

if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
end
    col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};
figure(1);
clf;
set(gcf, 'Position', [313 98.6000 1.2176e+03 663.4000]);
h1 = axes('Position', [0.1 0.6 0.25 0.3]);
axis square
hold on
histogram(paramFit.alpha, 10, 'FaceColor', col2plot{1});
xlabel('Fitted \alpha');
ylabel('Frequency');
title('\fontsize{14} \alpha');
set(gca, 'FontName', 'Arial');
h2 = axes('Position', [0.1 0.2 0.25 0.3]);
axis square
hold on
histogram(paramFit.beta, 10, 'FaceColor', col2plot{1});
xlabel('Fitted \beta');
ylabel('Frequency');
title('\fontsize{14} \beta');
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
end