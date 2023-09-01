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
            params2run.Q0    = params.Q0;
            [Qall{countalpha, countbeta}, choiceType{countalpha, countbeta}, totalStim{countalpha, countbeta}]...
                = sim_RW_riskPref(params2run, dist{idist}, nIters);
            [all, ~] = calculate_riskPref(choiceType{countalpha, countbeta}, totalStim{countalpha, countbeta});
            for itype = 1:2
    
                mean2plot_risk{idist, itype}(countalpha, countbeta) = nanmean(all{itype});
                sem2plot_risk{idist, itype}(countalpha, countbeta)  = nanstd(all{itype})./sqrt(length(all{itype}));
    
    
            end
        end
    end
end
for idist = 1:2
    for itype = 1:2
        if idist == 1
            if itype == 1
                axes(h1);
                axis square
            else
                axes(h2);
                axis square
            end
        else
            if itype == 1
                axes(h3);
                axis square
            else
                axes(h4);
                axis square
            end
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
                ttext = [{dist{idist},' P(Risky): LL'}];
            else
                ttext = [{dist{idist},' P(Risky): HH'}];
            end
            title(ttext, 'FontWeight', 'bold', 'FontSize', 12);
            set(gca, 'FontName', 'Arial');
    end
end

C = colormap(flipud(cbrewer2('RdBu', 100)));
gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
%             C1.Limits   = [0.2 0.6];
set(gcf, 'Position', [505 51.4000 816 731.2000]);


end