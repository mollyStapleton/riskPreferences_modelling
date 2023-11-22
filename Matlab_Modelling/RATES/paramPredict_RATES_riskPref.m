function paramPredict_RATES_riskPref(params, dist, nIters)

figure(1);

for idist = 1: length(dist)
    countalpha_pos = 0; countalpha_neg = 0; countbeta = 0;

    for ibeta = params.beta

        countbeta  = countbeta + 1;
        countalpha_pos = 0; countalpha_neg = 0;

        for ialpha_pos = params.alpha_pos           
            
            countalpha_pos = countalpha_pos + 1;
            countalpha_neg = 0;

            for ialpha_neg = params.alpha_neg
                
                countalpha_neg = countalpha_neg + 1;
        
                params2run.alpha_pos = ialpha_pos;
                params2run.alpha_neg = ialpha_neg;
                params2run.beta  = ibeta;
                params2run.Q0    = params.Q0;

                [p_risky_t{countbeta}{countalpha_pos, countalpha_neg}, p_high_t{countbeta}{countalpha_pos, countalpha_neg},...
                    ~] = sim_RATES_riskPref(params2run, dist{idist}, nIters);

                for icnd = 1:2
                    mean2plot_risk{idist, icnd}{countbeta}(countalpha_pos, countalpha_neg) = ...
                        nanmean(p_risky_t{count_beta}{countalpha_pos, countalpha_neg}(icnd,:));
                end

                for istim = 1:4
                    accPlot{istim}{countbeta}(countalpha_pos, countalpha_neg) = ...
                        nanmean(p_high_t{count_beta}{countalpha_pos, countalpha_neg}(istim, :));
                end
               
            end
        end
    end
end

% set indices for subplot locations 
plotLoc = [{[1 5 9 13 17; 2 6 10 14 18]}, {[3 7 11 15 19; 4 8 12 16 20]}];
C = colormap(flipud(cbrewer2('RdBu')));
for idist = 1:2
    for itype = 1:2
        for iplot = 1: length(plotLoc{idist}(1, :))
            ax2plot = subplot(5, 4, plotLoc{idist}(itype, iplot));
            axes(ax2plot);
            axis square
            hold on
            imagesc(mean2plot_risk{idist, itype}{iplot});
            set(gca,'Ydir','normal');
            set(gca, 'XTick', [1: 4: length(params.alpha_neg)]);
            set(gca, 'YTick', [1: 4: length(params.alpha_pos)]);
            set(gca, 'XLim', [1 length(params.alpha_neg)]);
            set(gca, 'YLim', [1 length(params.alpha_pos)]);
            set(gca, 'XTickLabel', round(params.alpha_neg(1:4:end), 2));
            set(gca, 'XTickLabelRotation', 45);
            xlabel('\fontsize{12} \bf \alphaNEG');
            ylabel('\fontsize{12} \bf \alphaPOS');
            set(gca, 'YTickLabel', round(params.alpha_pos(1:4:end), 2));
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