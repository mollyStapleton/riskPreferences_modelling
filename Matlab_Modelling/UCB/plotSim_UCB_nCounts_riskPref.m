function plotSim_UCB_nCounts_riskPref(p_risky_t, p_high_t, Qall, UCBall, model, dist)

if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    C = [colormap(cbrewer2('BuPu', 40))];
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    C =  [colormap(cbrewer2('YlGn', 40))];
end

figure(1);
subplot(2, 2, 1);
axis square 

%--------------------------------------------------------------------------
% P(RISKY) OVERALL
%------------------------------------------------------------------------------
for icnd = 1:2
    hold on 
    [hb hbErr] = barwitherr([nanstd(p_risky_t(icnd, :))./sqrt(length(p_risky_t(icnd, :)))],...
        [nanmean(p_risky_t(icnd, :))], 'FaceColor', col2plot{icnd}, 'EdgeColor', col2plot{icnd});    
    hb.XData = icnd;
    hbErr.XData = icnd;
end
ylim([0 1]);
xlim([0 3]);
hold on
plot([0 3], [0.5 0.5], 'k--');
set(gca, 'XTick', [1:2]);
set(gca, 'XTickLabels', {'\bfLL', '\bfHH'});
set(gca, 'XTickLabelRotation', 45);
title('\fontsize{12} \bfRisk Preferences');
set(gca, 'FontName', 'Arial')

%--------------------------------------------------------------------------
% P(RISKY) TRIAL BINNED
%------------------------------------------------------------------------------
subplot(2, 2, 3);
axis square
bin = [1:24:120];
binSize = 24;
for icnd = 1:2
    for ibin = 1: length(bin)
        meanRisk(icnd, ibin) = nanmean(p_risky_t(icnd, (bin(ibin): (bin(ibin) + binSize -1))));
        semRisk(icnd, ibin) = nanstd(p_risky_t(icnd, (bin(ibin): (bin(ibin) + binSize -1))))...
        /sqrt(length(p_risky_t(icnd, (bin(ibin): (bin(ibin) + binSize -1)))));
    
    end
hold on 
errorbar(meanRisk(icnd, :), semRisk(icnd, :), 'color', col2plot{icnd}, 'linew', 1.2);
end
xlim([0 6]);
ylim([0 1]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
ylabel('\bfP(Risky)');
xlabel('\bfTrial Bin No.');
set(gca, 'FontName', 'Arial');

%--------------------------------------------------------------------------
% P(HIGH) OVERALL
%------------------------------------------------------------------------------
subplot(2, 2, 2);
axis square
for istim = 1:4
    hold on 
    [hb hbErr] = barwitherr([nanstd(p_high_t(istim, :))./sqrt(length(p_high_t(istim, :)))],...
        [nanmean(p_high_t(istim, :))], 'FaceColor', C(istim*10, :), 'EdgeColor', C(istim*10, :));    
    hb.XData = istim;
    hbErr.XData = istim;
end
xlim([0 5]);
ylim([0 1]);
hold on 
ylabel('\bfP(High)');
plot([0 6], [0.5 0.5], 'k--');
legend({'HHSafe-LLSafe', '', 'HHSafe-LLRisky','', 'HHRisky-LLSafe','', 'HHRisky-LLRisky',  ''}, 'location', [0.47 0.47 0.1 0.1]);
title('\fontsize{12} \bfAccuracy');

%--------------------------------------------------------------------------
% P(HIGH) TRIAL BINNED
%------------------------------------------------------------------------------
subplot(2, 2, 4);
axis square
bin = [1:24:120];
binSize = 24;
for istim = 1:4
    for ibin = 1: length(bin)
        meanAcc(istim, ibin) = nanmean(p_high_t(istim, (bin(ibin): (bin(ibin) + binSize -1))));
        semAcc(istim, ibin) = nanstd(p_high_t(istim, (bin(ibin): (bin(ibin) + binSize -1))))...
        /sqrt(length(p_high_t(istim, (bin(ibin): (bin(ibin) + binSize -1)))));
    
    end
hold on 
errorbar(meanAcc(istim, :), semAcc(istim, :), 'color', C(istim*10, :), 'linew', 1.2);
end
xlim([0 6]);
ylim([0 1]);
hold on 
plot([0 6], [0.5 0.5], 'k--');
ylabel('\bfP(High)');
xlabel('\bfTrial Bin No.');
set(gca, 'FontName', 'Arial');
figure(1);
set(gcf, 'Position', [2.0114e+03 -56.6000 781.6000 699.2000]);
figure(2);
set(gcf, 'Position', [2793 -58.2000 796.8000 700.8000]);
subplot(2, 2, 1);
axis square
QC = [1 1 1; col2plot{1}; 1 1 1; col2plot{2}];
QCout = [col2plot{1}; col2plot{1}; col2plot{2}; col2plot{2}];

for istim = 1:4
    hold on 
    [hb hbErr] = barwitherr([nanstd(nanstd(Qall{istim}))./sqrt(length(Qall{istim}))],...
        [nanmean(nanmean(Qall{istim}))], 'FaceColor', QC(istim, :), 'EdgeColor', QCout(istim, :));    
    hb.XData = istim;
    hbErr.XData = istim;
end
xlim([0 5]);
ylim([0 80]);
hold on 
plot([0 2.5], [40 40], 'b-', 'linew', 1.2);
plot([2.5 5], [60 60], 'r-', 'linew', 1.2);
ylabel('\bfAverage Q');
set(gca, 'XTick', [1 4]);
set(gca, 'XTickLabel', {'\bfLL-Safe', '\bfLL-Risky', '\bfHH-Safe', '\bfHH-Risky'});
set(gca, 'XTickLabelRotation', 45);
set(gca, 'FontName', 'Arial');
title('\bf\fontsize{12} Average Q')

subplot(2, 2, 3);
axis square
lstyle = {'--', '-', '--', '-'};
for istim = 1:4
    for ibin = 1: length(bin)
        meanQ(istim, ibin) = nanmean(nanmean(Qall{istim}(bin(ibin): (bin(ibin) + binSize -1))));
        semQ(istim, ibin) = nanstd(Qall{istim}(bin(ibin): (bin(ibin) + binSize -1)))...
        /sqrt(length((bin(ibin): (bin(ibin) + binSize -1))));
    
    end
hold on 
errorbar(meanQ(istim, :), semQ(istim, :), 'color', QCout(istim, :), 'linestyle', lstyle{istim}, 'linew', 1.2);
end
xlim([0 6]);
ylabel('\bfAverage Q');
xlabel('\bfTrial Bin No.');
set(gca, 'FontName', 'Arial');
legend({'LL-Safe', 'LL-Risky', 'HH-Safe', 'HH-Risky'}, 'location', [0.47 0.47 0.1 0.1]);

subplot(2, 2, 2);
axis square
for istim = 1:4
    hold on 
    [hb hbErr] = barwitherr([nanstd(nanstd(UCBall{istim}))./sqrt(length(UCBall{istim}))],...
        [nanmean(nanmean(UCBall{istim}))], 'FaceColor', QC(istim, :), 'EdgeColor', QCout(istim, :));    
    hb.XData = istim;
    hbErr.XData = istim;
end
xlim([0 5]);
hold on 
ylabel('\bfAverage UCB');
set(gca, 'XTick', [1 4]);
set(gca, 'XTickLabel', {'\bfLL-Safe', '\bfLL-Risky', '\bfHH-Safe', '\bfHH-Risky'});
set(gca, 'XTickLabelRotation', 45);
set(gca, 'FontName', 'Arial');
title('\bf\fontsize{12} Average UCB')

subplot(2, 2, 4);
axis square
lstyle = {'--', '-', '--', '-'};
for istim = 1:4

        meanUCB(istim, :) = nanmean(UCBall{istim});
        semUCB(istim, :) = nanstd(UCBall{istim});
        hold on 
        plot(meanUCB(istim, :), 'color', QCout(istim, :), 'linestyle', lstyle{istim}, 'linew', 1.2);
        hold on
        x = 1:120;
        % Calculate upper and lower bounds for the shaded area
%         y_upper = meanUCB(istim, :) + semUCB(istim, :);
%         y_lower = meanUCB(istim, :) - semUCB(istim, :);
        % Create a shaded area between the upper and lower bounds
%         
%         fill([x(1:end-1), fliplr(x(1:end-1))], [y_upper(1:end-1), fliplr(y_lower(1:end-1))], QCout(istim, :),...
%             'FaceAlpha', 0.25, 'EdgeColor', QCout(istim, :));

end

xlim([0 120]);
ylabel('\bfAverage UCB');
xlabel('\bfTrial Bin No.');
set(gca, 'FontName', 'Arial');

end
