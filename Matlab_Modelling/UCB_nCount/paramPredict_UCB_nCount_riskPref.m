function paramPredict_UCB_nCount_riskPref(params, dist, nIters)

figure(1);


for idist = 1: length(dist)
   countalpha = 0; countc = 0; countbeta = 0;

    for ibeta = params.beta

       countbeta  = countbeta + 1;
       countalpha = 0; countc = 0;

        for ialpha = params.alpha           
            
            countalpha = countalpha + 1;
            countc = 0;

            for ic = params.c
                
                countc = countc + 1;
        
                params2run.alpha = ialpha;
                params2run.c = ic;
                params2run.beta  = ibeta;
                params2run.Q0    = params.Q0;
                [p_risky_t{countbeta}{countalpha, countc}, p_high_t{countbeta}{countalpha, countc},...
                    ~, ~]= sim_UCB_nCount_riskPref(params2run, dist{idist}, nIters);

                for icnd = 1:2
                    mean2plot_risk{idist, icnd}{countbeta}(countalpha, countc) = ...
                        nanmean(p_risky_t{countbeta}{countalpha, countc}(icnd,:));
                end

                for istim = 1:4
                    accPlot{istim}{countbeta}(countalpha, countc) = ...
                        nanmean(p_high_t{countbeta}{countalpha, countc}(istim, :));
                end
            end
        end
    end
end

% set indices for subplot locations 
% plotLoc = [{[1 5 9 13 17; 2 6 10 14 18]}, {[3 7 11 15 19; 4 8 12 16 20]}];
plotLoc   = [1 3 5 7 9; 2 4 6 8 10];
C = colormap(flipud(cbrewer2('RdBu')));
for idist = 1
    for itype = 1:2
%         for iplot = 1: length(plotLoc{idist}(1, :))
        for iplot = 1: length(plotLoc(itype, :))
            ax2plot = subplot(5, 2, plotLoc(itype, iplot))
%             ax2plot = subplot(5, 4, plotLoc{idist}(itype, iplot));
            axes(ax2plot);
            axis square
            hold on
            imagesc(mean2plot_risk{idist, itype}{iplot});
            set(gca,'Ydir','normal');
            set(gca, 'XTick', [1: 4: length(params.c)]);
            set(gca, 'YTick', [1: 4: length(params.alpha)]);
            set(gca, 'XLim', [1 length(params.c)]);
            set(gca, 'YLim', [1 length(params.alpha)]);
            set(gca, 'XTickLabel', round(params.c(1:4:end), 2));
            xlabel('\fontsize{12} \bf c');
            ylabel('\fontsize{12} \bf \alpha');
            set(gca, 'YTickLabel', round(params.alpha(1:4:end), 2));
            set(gca, 'XTickLabelRotation', 45);
            if iplot == 1
                if itype == 1
                    ttext = [{dist{idist},' P(Risky): LL'}];
                else
                    ttext = [{dist{idist},' P(Risky): HH'}];
                end
                title(ttext, 'FontWeight', 'bold', 'FontSize', 12);
            end
            
            set(gca, 'FontName', 'Arial');
            caxis([0 1]);
        end
    end
end

gcf;
C1 = colorbar;
C1.Position = [0.93 0.27 0.03 0.5];
C1.Limits   = [0 1];
set(gcf, 'Position', [232.2000 1.8000 1.2688e+03 780.8000]);
end
