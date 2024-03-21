function plotFit_riskPref_joint(dataIn, paramFit, model, dist)

figure(1);
clf;
% set(gcf, 'Position', [2.0226e+03 -50.2000 1.4568e+03 728]);
set(gcf, 'Position', [-11.8000 20.2000 1.5344e+03 750.4000]);
h1 = axes('Position', [0.001 0.35 0.4 0.4]);
axis square
hold on 
if strcmpi(model, 'RW')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', [0.7 0.7 0.7]);
    set(gca, 'XTickLabel', {'\alpha', '\beta'});
    ylim([0 3]);
elseif strcmpi(model, 'RATES')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', [0.7 0.7 0.7]);
    set(gca, 'XTickLabel', {'\alphaPos', '\alphaNeg', '\beta'});
elseif strcmpi(model, 'UCB_nCount')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', [0.7 0.7 0.7]);
    set(gca, 'XTickLabel', {'\alpha', '\beta', 'c'})
elseif strcmpi(model, 'UCB_spread')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', [0.7 0.7 0.7]);
    set(gca, 'XTickLabel', {'\alphaQ', '\alphaS',  '\beta', 'c', 'S0'})
elseif strcmpi(model, 'PEIRS')
    ba = boxchart([paramFit.fittedParams], 'BoxFaceColor', [0.7 0.7 0.7]);
    set(gca, 'XTickLabel', {'\alphaQ', '\alphaS',  '\beta', 'S0', '\omega'})
end

for ic = 1: size(paramFit.fittedParams, 2)   
    xscatt_coord(1: size(paramFit.fittedParams, 1), ic) = ic;    
end
hold on 
plot(xscatt_coord, paramFit.fittedParams, '.', 'Color', [0.7 0.7 0.7], 'MarkerSize', 15);
ylabel('Fitted Parameter Values');
title('Descriptives');
set(gca, 'FontName', 'Arial');

h2 = axes('Position', [0.33 0.52 0.125 0.4]);
h3 = axes('Position', [0.47 0.52 0.125 0.4]);
hold on

if strcmpi(dist, 'Joint')
    distIdx = [1 2] % both distribution fits present 
elseif strcmpi(dist, 'Gaussian')
    distIdx = 1;
elseif strcmpi(dist, 'Bimodal')
    distIdx = 2;
end

for idist = 1: length(distIdx)

    if distIdx(idist) == 1
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
        C = [colormap(cbrewer2('BuPu', 40))];
        x2plot = [1 1.5]

    else
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
        C =  [colormap(cbrewer2('YlGn', 40))];
        x2plot = [2.5 3];
    end

    col2plot_fit = {[0.7 0.7 0.7], [0 0 0]};
    CFit =  [colormap(cbrewer2('Greys', 40))];
    
    data2plot = []
    data2plot = dataIn(dataIn.dist == distIdx(idist), :);

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
                meanData = data2plot.meanTrue;
                colPlot  = col2plot;
            else
                meanData = data2plot.meanFit;
                colPlot  = col2plot_fit;
            end

            mean2plot(itype, icnd) = nanmean(meanData(:, icnd));
            sem2plot(itype, icnd)  = nanstd(meanData(:, icnd))./sqrt(length(meanData(:, icnd)));
            hold on
            plot(itype, meanData(:, icnd), '.', 'color', colPlot{icnd}, 'MarkerSize', 15);
            hold on
            [hb, hberr] = barwitherr(sem2plot(itype, icnd), mean2plot(itype, icnd), 'FaceColor',...
                'none', 'EdgeColor', colPlot{icnd}, 'linew', 2);
            hb.XData = itype;
            hberr.LineWidth = 1
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


end





end 