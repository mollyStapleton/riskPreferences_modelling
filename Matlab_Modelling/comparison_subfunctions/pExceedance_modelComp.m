clc; close all hidden; clear all;

%--------------------------------------------------------
% Load in full data matrix to check number of trials 
%----------------------------------------------------------------
cd('C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\data');
load('allTr_allSubjects.mat');

subs    = [21 22 23 24 26 28 29 30 32 33 34 35 36 37,...
        39 40 42 44 45 46 47 49 50 51 52 53 54 55 56 58];
dists   = [1 2];

%----------------------------------------------------------------
% Path to model fitting output
%------------------------------------------------------------------------
base_path = ['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\'];
fit_path  = ['modelling_figures\model_fits\'];
cd([base_path fit_path]);

models  = {'RW', 'RATES', 'UCB_nCount', 'UCB_spread', 'PEIRS'};

%-------------------------------------------------------
% SUBJECT IDX - satisfied inclusion criteria
%-------------------------------------------------------
subs    = [21 22 23 24 26 28 29 30 32 33 34 35 36 37,...
        39 40 42 44 45 46 47 49 50 51 52 53 54 55 56 58];


for imodel = 1: length(models)

    for isubject = 1: length(subs)
        for idist = 1:2
            subIdx = [];
            subIdx = find(allTr_allSubjects.pt_number == subs(isubject)...
                & allTr_allSubjects.distType == dists(idist));
            formData{imodel}(isubject, idist) =  length(subIdx);
        end
    end
    for idist = 1:2
        cd([base_path fit_path '\' models{imodel}]);
        %     load([models{imodel} '_subjectLvl_joint_paramFit.mat']);
        if idist == 1
            load([models{imodel} '_subjectLvl_paramFits_Gaussian.mat']);
            formData{imodel}(1: length(subs), 3) = size(data2save.fittedParams, 2);
            formData{imodel}(1: length(subs), 4) = data2save.LL;
        else
            load([models{imodel} '_subjectLvl_paramFits_Bimodal.mat']);
            formData{imodel}(1: length(subs), 5) = size(data2save.fittedParams, 2);
            formData{imodel}(1: length(subs), 6) = data2save.LL;
        end

%         formData{imodel} =  formData{imodel}.Properties.Variables;

    end

    formData{imodel} =  array2table(formData{imodel});
    formData{imodel}.Properties.VariableNames = {'nGauss', 'nBi', 'paramGauss', 'negLLGauss', 'paramBi', 'negLLBi'};
    for isubject = 1: length(subs)
        superBIC(isubject, imodel) = (formData{imodel}.paramGauss(isubject) + formData{imodel}.paramGauss(isubject)) *...
            (log(formData{imodel}.nGauss(isubject) + formData{imodel}.nBi(isubject))) -...
            (2 * (formData{imodel}.negLLGauss(isubject) + formData{imodel}.negLLBi(isubject)));
    end

        superBIC(:, imodel) = (-0.5)*superBIC(:, imodel);

end
opt.DisplayWin = 0;
[~,out_superBIC] = VBA_groupBMC(superBIC',opt);
%------------------------------------------------------
% JOINT MODEL FITS 
% can use values just as they are from raw fit output
%--------------------------------------------------------------
for imodel = 1: length(models)
        cd([base_path fit_path '\' models{imodel}]);
        load([models{imodel} '_subjectLvl_joint_paramFit.mat']);
        L(:, imodel) = (-0.5)*[data2save.BIC];

end

opt.DisplayWin = 0;
[~,out_joint] = VBA_groupBMC(L',opt);