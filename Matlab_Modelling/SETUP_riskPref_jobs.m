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

%-------------------------------------------------------
% SUBJECT IDX - satisfied inclusion criteria
%-------------------------------------------------------
subs = [21 22 23 24 26 28 29 30 32 33 34 35 36 37,...
    39 40 42 44 45 46 47 49 50 51 52 53 54 55 56 58];
% subs = 23;
%------------------------------------------------------
% SELECT MODEL TO WORK WITH
%--------------------------------------------------------------
models                  = {'RW', 'RATES', 'UCB_nCount', 'UCB_spread', 'PEIRS'};
models2run              = [1];
nIters                  = 50;
%------------------------------------------------------------
% SET REWARD DISTRIBUTION
%-----------------------------------------------------------------
distSplit   = 1; % whether to collapse all distributions or perform jobs separately
dists       = {'Gaussian', 'Bimodal'};
dists2run   = [2];

%-------------------------------------------------------------
%-------------------------------------------------------------
% SELECT JOB TO RUN
%-------------------------------------------------------------------
%-------------------------------------------------------------
simulate_data           = 0;  % Simulate model fits
simulate_model_effects  = 0;  % Simulate parameter effects on risk preferences
model_fit_to_data       = 1;  % Fit model to existing data
genData_plotFit         = 0;  % Generate data matrix to plot true vs fitted data
                              % Generate individual subject true vs fitted
                              % data plots
plot_data_model_comp    = 0;  % Generate average plots for true vs fitted data for all subjects


%-------------------------------------------------------------
%-------------------------------------------------------------
% CHECK PARAMETER INPUTS ARE CORRECT FOR THE SELECTED JOB
%-------------------------------------------------------------------
%-------------------------------------------------------------

for imodel = 1: length(models2run)

    if simulate_data 
        %--------------------------------------------------
        % SINGLE PARAMETER VALUE TO BE ENTERED
        % used to generate simulated behaviour
        %--------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = 0.2220; %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = 0.3323;
        elseif strcmpi(models{models2run(imodel)} , 'RATES')
            params.alpha_pos    = 0.86;
            params.alpha_neg    = 0.48;
        elseif strcmpi(models{models2run(imodel)}, 'UCB_nCount')
            params.alpha        = 0.2;
            params.c            = 5;
        elseif strcmpi(models{models2run(imodel)}, 'UCB_spread')
            params.alpha        = 0.5;
            params.c            = 0.5;
            params.s            = [5 15 5 15];
        elseif strcmpi(models{models2run(imodel)}, 'PEIRS')
            params.S0           = 0.15;
            params.alphaQ       = 0.25;
            params.alphaS       = 0.15;
            params.omega        = 0.03;
        end
    elseif simulate_model_effects
        %--------------------------------------------------
        % VECTOR OF PARAMETER VALUES TO BE ENTERED
        % used to generate plots of average risk pref, given a set of
        % parameters 
        %--------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = linspace(0.1, 3, 20); %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = linspace(0.1, 1, 20);
        elseif strcmpi(models{models2run(imodel)} , 'RATES')
            params.alpha_pos    = linspace(0.1, 1, 20);
            params.alpha_neg    = linspace(0.1, 1, 20);
        elseif strcmpi(models{models2run(imodel)}, 'UCB_nCount')
            params.alpha        = linspace(0.1, 1, 20);
            params.c            = linspace(1, 2, 20);
        elseif strcmpi(models{models2run(imodel)}, 'PEIRS')
            params.S0           = 0.15;
            params.alphaQ       = 0.25;
            params.alphaS       = 0.15;
            params.omega        = 0.03;
        end
    elseif model_fit_to_data
        %--------------------------------------------------
        % VECTOR OF PARAMETER VALUES TO BE ENTERED
        % used to perform single-point MLE model fitting to existing
        % behavioural data
        %--------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = (0 - 3) * rand(1, nIters) + 3;
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = rand(1, nIters);
        elseif strcmpi(models{models2run(imodel)} , 'RATES')
            params.alpha_pos    = linspace(0.1, 1, 10);
            params.alpha_neg    = linspace(0.1, 1, 10);
        elseif strcmpi(models{models2run(imodel)}, 'UCB')
            params.alpha        = 0.25;
            params.c            = 1;
            params.S            = 0.2;
        elseif strcmpi(models{models2run(imodel)}, 'PEIRS')
            params.S0           = 0.15;
            params.alphaQ       = 0.25;
            params.alphaS       = 0.15;
            params.omega        = 0.03;
        end
    end
            runSelectedJobs;
end    

