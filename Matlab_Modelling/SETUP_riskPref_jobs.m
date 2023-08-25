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
models2run              = [1];
nIters                  = 1000;
%-------------------------------------------------------------
% SET PARAMETERS, ** this is mainly to be used for simulation purposes, for
% model fitting a series of parameters to be fit are generated within each
% script
%----------------------------------------------------------------
params.Q0    = 50; % FIXED PARAMETER, DO NOT CHANGE 
params.beta  = 0.03; %softmax temperature parameter included in all models

for iparam = 1: length(models2run)
    if strcmpi(models{models2run} , 'RW')
        params.alpha = 0.15;
    elseif strcmpi(models{models2run} , 'RATES')
        params.alpha_pos = [];
        params.alpha_neg = [];
    elseif strcmpi(models{models2run} , 'UCB')
        params.alpha = [];
        params.c     = [];
        params.S     = [];
    elseif strcmpi(models{models2run} , 'PEIRS')    
        params.S0 = [];
        params.alphaQ = [];
        params.alphaS = [];
        params.omega  = [];
    end
end

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
        for idist = 1: length(dists2run)
            sim_riskPref(models{models2run}, params, dists{dists2run}, nIters);
        end
    end

end
