%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if simulate_data
    
        clf;
        for idist = 1: length(dists2run)
            sim_riskPref(models{models2run(imodel)}, params, dists{dists2run(idist)}, nIters);
        end

        gcf;
        if ~strcmpi(models{models2run(imodel)}, 'PEIRS')
            set(gcf, 'Position', [661 -10.2000 826.4000 721.6000]);
        else 
            set(gcf, 'Position', [111.4000 10.6000 1.2392e+03 636]);
        end
            cd([base_path save_path '\simulations\' models{models2run(imodel)} '\' dists{dists2run(idist)}]);

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if simulate_model_effects

    clf;
    parPredict_riskPref(models{models2run(imodel)}, params, dists(dists2run), nIters);
    saveFigname = ['risk_pref_paramPredictions_lowerBeta'];
    cd([base_path save_path '\parameter_simulations']);
    figure(1);    
    print(saveFigname, '-dpng');

%     figure(2);
%     saveFigname = ['accuracy_' models{models2run(imodel)} '_' dists{dists2run} '_paramPredictions_lowerBeta'];
%     print(saveFigname, '-dsvg');
%     print(saveFigname, '-dpng');

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if model_fit_to_data
    data2save = [];

    %   load in relevant subject data
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');


    for isubject = 1: length(subs)
        data2run   = allTr_allSubjects([allTr_allSubjects.pt_number == subs(isubject)], [1:10 16]);
        [best_fit_parm(isubject, :), LL(isubject), BIC(isubject)] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists{dists2run}, distSplit, nIters);
        tmpData = [subs(isubject) best_fit_parm(isubject,1) best_fit_parm(isubject, 2) LL(isubject) BIC(isubject)];
        data2save = [data2save; tmpData];
    end

    delete(gcp('nocreate'));
    data2save = array2table(data2save);
    data2save.Properties.VariableNames = {'ptIdx', 'alpha', 'beta', 'LL', 'BIC'};
    saveTablename = [models{models2run} '_subjectLvl_paramFits_Q0_' dists{dists2run} '.mat'];
    cd([base_path save_path '\model_fits\' models{models2run}]);
    save( saveTablename, 'data2save');
    delete(gcp('nocreate'));
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if genData_plotFit
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');
    cd([base_path save_path '\model_fits\' models{models2run}]);
    load([models{models2run} '_subjectLvl_paramFits_Q0_' dists{dists2run} '.mat'])
    %load in previously generated parameter fits
    dataFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat'];
    if exist(dataFilename)
        for isubject = 1: length(subs)

            trueData   = allTr_allSubjects([allTr_allSubjects.pt_number == subs(isubject)], :);
            paramFit    = data2save(data2save.ptIdx == subs(isubject), :);
            clf;
            [meanTrue(isubject, :), meanFit(isubject, :), binnedTrue(isubject, :), binnedFit(isubject, :)...
                meanAccTrue(isubject, :), meanAccFit(isubject, :), accTrue_binned{isubject}, accFit_binned{isubject}]...
                = genData_riskPref_modelComp(trueData, paramFit, models{models2run}, dists{dists2run});

            cd([base_path save_path '\model_fits\' models{models2run} '\subjectSpecific\' dists{dists2run}]);
            saveFigname = ['PT_' num2str(subs(isubject)) '_Q0'];
            print(saveFigname, '-dpng');
        end

        % save risk preference data: TRUE and FITTED

        plotData.meanTrue       = meanTrue;
        plotData.meanFit        = meanFit;
        plotData.binnedTrue     = binnedTrue;
        plotData.binnedFit      = binnedFit;
        plotData.accFit         = meanAccFit;
        plotData.accTrue        = meanAccTrue;
        plotData.accTrue_binned = accTrue_binned;
        plotData.accFit_binned  = accFit_binned;
        cd([base_path save_path '\model_fits\RW']);
        saveFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '_Q0.mat'];
        save(saveFilename, 'plotData');
    end
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if plot_data_model_comp
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');

    % load in fitted parameters
    cd([base_path save_path '\model_fits\' models{models2run}]);
    load([models{models2run} '_subjectLvl_paramFits_Q0_' dists{dists2run} '.mat'])

    % load in data: 1) true data and 2) generated using fitted parameters
    % generated using
    dataFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '_Q0.mat'];
    load(dataFilename);
    paramFits = data2save;

    plotFit_riskPref(plotData, paramFits, models{models2run}, dists{dists2run});

    figSavename_1 = [models{models2run} '_' dists{dists2run} '_modelFit_riskPref_Q0'];
    figure(1);
    print(figSavename_1, '-dpng');
end