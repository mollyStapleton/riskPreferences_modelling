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
models2run              = [2];
nIters                  = 100;

%------------------------------------------------------------
% SET REWARD DISTRIBUTION
%-----------------------------------------------------------------
distSplit   = 1; % whether to collapse all distributions or perform jobs separately
dists       = {'Gaussian', 'Bimodal'};
dists2run   = [1];
%-------------------------------------------------------------
% SELECT JOB TO RUN
%-------------------------------------------------------------------
simulate_data           = 0;  % Simulate model fits
simulate_model_effects  = 1;  % Simulate parameter effects on risk preferences
model_fit_to_data       = 0;  % Fit model to existing data


%-----------------------------------------------------------------------------
% SIMULATE DATA 
%---------------------------------------------------------------------------------
% takes user specified parameters to generate simulated data 
% for RW, RATES and UCB: plots to show change to Q over time, all trial
%                        P(Risky) and binned P(risky)
% for PEIRS:             plots to show change to Q and S over time, all trial
%                        P(Risky) and binned P(risky)
%------------------------------------------------------------------------------------
if simulate_data

    for imodel = 1: length(models2run)
        %-------------------------------------------------------------
        % SET PARAMETERS, ** this is mainly to be used for simulation purposes, for
        % model fitting a series of parameters to be fit are generated within each
        % script
        %----------------------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = 0.8; %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = 0.3;
        elseif strcmpi(models{models2run(imodel)} , 'RATES')
            params.alpha_pos    = 0.25;
            params.alpha_neg    = 0.15;
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

        clf;
        for idist = 1: length(dists2run)
            sim_riskPref(models{models2run(imodel)}, params, dists{idist}, nIters);
        end


        gcf;
        if ~strcmpi(models{models2run(imodel)}, 'PEIRS')
            set(gcf, 'Position', [369.8000 247.4000 1.1616e+03 514.6000]);
        else 
            set(gcf, 'Position', [111.4000 10.6000 1.2392e+03 636]);
        end
            cd([base_path save_path '\simulations'])
            figSavename = [models{models2run(imodel)}];
            print(figSavename, '-dsvg');
            print(figSavename, '-dpng');

        end

end

%-----------------------------------------------------------------------------
% SIMULATE MODEL EFFECTS 
%---------------------------------------------------------------------------------
% takes user specified VECTOR of parameters to demonstrate effects over
% P(Risky)
% MODELS:
% RW: vector for beta and alpha, returns changes to P(Risky) as 2D plot
% RATES:
% UCB:
% PEIRS:
%------------------------------------------------------------------------------------

if simulate_model_effects 

    for imodel = 1: length(models2run)
        %-------------------------------------------------------------
        % SET VARIABLE PARAMETERS TO GENERATE P(RISKY) AS A FUNCTION OF
        % DIFFERENT PARAMETERS > FIGURES TO BE USED TO SHOW MODEL
        % PREDICTIONS 
        %----------------------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = linspace(0.1, 1, 10); %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = linspace(0.1, 1, 10);
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

            clf;
            parPredict_riskPref(models{models2run(imodel)}, params, dists, nIters);
            saveFigname = [models{models2run(imodel)} '_paramPredictions'];
            cd([base_path save_path '\parameter_simulations']);
            print(saveFigname, '-dsvg');
            print(saveFigname, '-dpng');
    end

end

%-----------------------------------------------------------------------------
% MODEL FITTING
%---------------------------------------------------------------------------------
% MLE single-point estimates returned
% runs on a subject by subject basis
%------------------------------------------------------------------------------------


if model_fit_to_data 
%   load in relevant subject data
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');
    subs = unique(allTr_allSubjects.pt_number);
%     subIdx = [{'019', '020', '021', '022', '023', '024',...
%     '025', '026', '027', '028', '029', '030', '031',...
%     '033', '034', '036', '037', '038',...
%     '039', '040', '042', '044', '045', '046', '047', '048', '049', '050'}];

    for imodel = 1: length(models2run)
        %-------------------------------------------------------------
        % SET VARIABLE PARAMETERS TO GENERATE P(RISKY) AS A FUNCTION OF
        % DIFFERENT PARAMETERS > FIGURES TO BE USED TO SHOW MODEL
        % PREDICTIONS 
        %----------------------------------------------------------------
        params.Q0               = 50; % FIXED PARAMETER, DO NOT CHANGE
        params.beta             = exp(normrnd(-2, 2, [1 nIters])); %softmax temperature parameter included in all models
        if strcmpi(models{models2run(imodel)} , 'RW')
            params.alpha        = VBA_sigmoid(normrnd(-1, 2, [1 nIters]));
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

            for isubject = 1: length(subs)

                data2run   = allTr_allSubjects([allTr_allSubjects.pt_number == 19], [1:10 15]);
                
                [best_fit_parm, LL, BIC] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists, distSplit, nIters);
                saveFigname = [models{models2run(imodel)} '_paramPredictions'];
                cd([base_path save_path '\parameter_simulations']);
                print(saveFigname, '-dsvg');
                print(saveFigname, '-dpng');
            end
    end

end