function paramPredict_RW_riskPref(params, dist, nIters)

figure(1);
h1 = subplot(1, 2, 1); %Q estimates
h2 = subplot(1, 2, 2); %P(risky) estimates
if strcmp(dist, 'Gaussian')
    col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
else
    col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
end

countalpha = 0; countbeta = 0;
for ialpha = params.alpha
    countalpha = countalpha + 1;
    countbeta  = 0;

    for ibeta = params.beta
        countbeta  = countbeta + 1;
        params2run.alpha = ialpha;
        params2run.beta  = ibeta;
        params2run.Q0    = params.Q0;
        [Qall{countalpha, countbeta}, choiceType{countalpha, countbeta}, totalStim{countalpha, countbeta}]...
            = sim_RW_riskPref(params2run, dist, nIters);
        [all, ~] = calculate_riskPref(choiceType{countalpha, countbeta}, totalStim{countalpha, countbeta});
        for itype = 1:2

            mean2plot_risk{itype}(countalpha, countbeta) = nanmean(all{itype});
            sem2plot_risk{itype}(countalpha, countbeta)  = nanstd(all{itype})./sqrt(length(all{itype}));


        end
    end
end

for itype = 1:2
    if itype == 1
        axes(h1);
        axis square
    else
        axes(h2);
        axis square
    end
    hold on
    imagesc(mean2plot_risk{itype});
    set(gca,'Ydir','normal');
    set(gca, 'XTick', [1:length(params.alpha)]);
    set(gca, 'YTick', [1:length(params.beta)]);
    set(gca, 'XLim', [1 length(params.beta)]);
    set(gca, 'YLim', [1 length(params.alpha)]);
    set(gca, 'XTickLabel', params.alpha);
    xlabel('\fontsize{12} \bf \beta');
    ylabel('\fontsize{12} \bf \alpha');
    set(gca, 'YTickLabel', params.beta);
    if itype == 1
        ttext = ['P(Risky): LL'];
    else
        ttext = ['P(Risky): HH'];
    end
    title(ttext, 'FontWeight', 'bold', 'FontSize', 12);
    C = colormap(cbrewer2('RdBu', 100));
    sgtitle(dist, 'FontWeight', 'bold', 'FontSize', 16);
    set(gca, 'FontName', 'Arial');
end
gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
%             C1.Limits   = [0.2 0.6];
set(gcf, 'Position', [488 347.4000 857 414.6000]);


end