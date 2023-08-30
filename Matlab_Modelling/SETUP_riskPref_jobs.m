%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MLE MODELLING ----------------------
%%%%% RISK PREFERENCES ----------------------
%%%%% Author: M. Stapleton, August 2023
%%%%% ------------------------------------------------
clc; close all hidden; clear all;
%-------------------------------------------------------
% PATH SETTING
%-------------------------------------------------------
base_path = ['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\'];
repo_path = ['riskPreferences_modelling\Matlab_Modelling\']
data_path = ['data'];
save_path = ['modelling_figures'];

cd([base_path repo_path]);

%------------------------------------------------------
% SELECT MODEL TO WORK WITH
%--------------------------------------------------------------
models                  = {'RW', 'RATES', 'UCB', 'PEIRS'};
models2run              = [3];
nIters                  = 1000;

%------------------------------------------------------------
% SET REWARD DISTRIBUTION 
%-----------------------------------------------------------------
dists       = {'Gaussian', 'Bimodal'};
dists2run   = [1];
%-------------------------------------------------------------
% SELECT JOB TO RUN 
%-------------------------------------------------------------------
simulate_data           = 1;  % Simulate model fits 
simulate_model_effects  = 0;  % Simulate parameter effects on risk preferences
model_fit_to_data       = 0;  % Fit model to existing data

if simulate_data

    for imodel = 1: length(models2run)
        %-------------------------------------------------------------
        % SET PARAMETERS, ** this is mainly to be used for simulation purposes, for
        % model fitting a series of parameters to be fit are generated within each
        % script
        %----------------------------------------------------------------
        params.Q0    = 50; % FIXED PARAMETER, DO NOT CHANGE 
        params.beta  = 0.6; %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha = 0.25;
        elseif strcmpi(models{models2run(imodel)} , 'RATES')
            params.alpha_pos = 0.25;
            params.alpha_neg = 0.15;
        elseif strcmpi(models{models2run(imodel)}, 'UCB')
            params.alpha = 0.25;
            params.c     = 1;
            params.S     = 0.2;
        elseif strcmpi(models{models2run(imodel)}, 'PEIRS')    
            params.S0 = [];
            params.alphaQ = [];
            params.alphaS = [];
            params.omega  = [];
        end

        clf;
        for idist = 1: length(dists2run)
            sim_riskPref(models{models2run(imodel)}, params, dists{idist}, nIters);
        end
    end

    gcf;
    set(gcf, 'Position', [369.8000 247.4000 1.1616e+03 514.6000]);
    cd([base_path save_path '\simulations'])
    figSavename = [models{models2run(imodel)}];
    print(figSavename, '-dpdf');
    print(figSavename, '-dpng');

end
