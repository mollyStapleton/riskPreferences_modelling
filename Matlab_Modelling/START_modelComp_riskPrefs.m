%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MLE MODEL COMPARISONS ----------------------
%%%%% RISK PREFERENCES ----------------------
%%%%% Author: M. Stapleton, FEB 2024
%%%%% ------------------------------------------------
%%%%% Batch scripts for model comparisons
%%%%% Models should already have been fit separately using the
%%%%% 'SETUP_riskPref_jobs.m' script batch 
%%%%%------------------------------------------------------------
clc; close all hidden; clear all;
%-------------------------------------------------------
% PATH SETTING
%-------------------------------------------------------
base_path = ['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\'];
fit_path  = ['modelling_figures\model_fits\'];
cd([base_path fit_path]);

%-------------------------------------------------------
% SUBJECT IDX - satisfied inclusion criteria
%-------------------------------------------------------
subs    = [21 22 23 24 26 28 29 30 32 33 34 35 36 37,...
        39 40 42 44 45 46 47 49 50 51 52 53 54 55 56 58];
%------------------------------------------------------
% MODEL LIST
%--------------------------------------------------------------
models  = {'RW', 'RATES', 'UCB_nCount', 'UCB_spread', 'PEIRS'};
%------------------------------------------------------
% REWARD DISTRIBUTION LIST
%--------------------------------------------------------------
dists   = {'Gaussian', 'Bimodal'};


BIC_plot = cell(1, 2);


for idist = 1: length(dists)
   
    BIC_plot{idist} = table();

    if strcmp(dists(idist), 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
        C = [colormap(cbrewer2('BuPu', 40))];
        
    else
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
        C =  [colormap(cbrewer2('YlGn', 40))];

    end

    for imodel = 1: length(models)

        model_path = cd([base_path fit_path models{imodel}]);
        modelFilename = [models{imodel} '_subjectLvl_paramFits_' dists{idist} '.mat'];
        load(modelFilename);

        BIC_plot{idist}(:, imodel) = array2table(data2save.BIC);
    
        BIC_barData(imodel, 1) = nanmean(table2array(BIC_plot{idist}(:, imodel)));
        BIC_barData(imodel, 2) = nanstd(table2array(BIC_plot{idist}(:, imodel)))./sqrt(size(BIC_plot{idist}(:, imodel), 1));

    end

    figure(1);
    if strcmp(dists(idist), 'Gaussian')
        subplot(1, 2, 1);
        axis square
    else 
        subplot(1, 2, 2);
        axis square
    end

    hold on 
    barwitherr(BIC_barData(:, 2), BIC_barData(:, 1),'FaceColor',...
                col2plot{1}, 'EdgeColor', col2plot{1}, 'linew', 2);
    hold on 
    for imodel = 1: length(models)
        
        plot(imodel, table2array(BIC_plot{idist}(:, imodel)), '.', 'MarkerSize', 15, 'color', col2plot{2});
    
    end
    ylabel('\bfAverage BIC');
    set(gca, 'XTick', [1:5]);
    set(gca, 'XTickLabel', {'\bfRW', '\bfRATES', '\bfUCB_1', '\bfUCB_2', '\bfPEIRS'});
    set(gca, 'XTickLabelRotation', 45);
    title(dists(idist), 'fontsize', 16);
    set(gca, 'FontName', 'Arial');
    

end

