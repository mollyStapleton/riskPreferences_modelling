%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if simulate_data
    
        clf;
        for idist = 1: length(dists2run)
            sim_riskPref(models{models2run(imodel)}, params, dists{dists2run(idist)}, nIters);
        end

        cd([base_path save_path '\simulations\' models{models2run(imodel)} '\']);
        if strcmpi(models{models2run(imodel)}, 'UCB_spread');
            figure(1);
            gcf;
            saveFigname = [dists{dists2run(idist)} '_riskPref_simulation'];
            print(saveFigname, '-dsvg');
            print(saveFigname, '-dpng');
            figure(2);
            gcf;
            saveFigname = [dists{dists2run(idist)} '_param_simulation'];
            print(saveFigname, '-dsvg');
            print(saveFigname, '-dpng');
        end

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if simulate_model_effects

    clf;
    parPredict_riskPref(models{models2run(imodel)}, params, dists(dists2run), nIters);
    saveFigname = [dists{dists2run} '_risk_pref_paramPredictions'];
    cd([base_path save_path '\parameter_simulations\' models{models2run(imodel)}]);
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
    data2save  = table();

    p = gcp('nocreate');
    if ~isempty(p)
        Nwork = p.NumWorkers;
    else
        Nwork = 0;
    end
    if Nwork ~= 4
        delete(gcp('nocreate'))
        %   parpool('local', 4, 'IdleTimeout', 30);
        parpool('local', 4);
    end

    for isubject = 1: length(subs)
        data2run   = allTr_allSubjects([allTr_allSubjects.pt_number == subs(isubject)], [1:10 16]);
        [best_fit_parm(isubject, :), LL(isubject), BIC(isubject)] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists{dists2run}, distSplit, nIters);
        
        data2save(isubject, :) = [subs(isubject) models{models2run(imodel)},...
            dists{dists2run} {best_fit_parm(isubject, :)} LL(isubject) BIC(isubject)];
    end

%     delete(gcp('nocreate'));
    % fitted params variable will be of different lengths for each model
    % makes more generalisable for future plotting scripts
    data2save.Properties.VariableNames = {'ptIdx', 'model', 'dist', 'fittedParams', 'LL', 'BIC'};
    saveTablename = [models{models2run} '_PT_' num2str(subs(isubject)) '_paramFits_' dists{dists2run} '.mat'];
%     saveTablename = [models{models2run} '_subjectLvl_paramFits_' dists{dists2run} '.mat'];
    cd([base_path save_path '\model_fits\' models{models2run}]);
    save( saveTablename, 'data2save');
%     delete(gcp('nocreate'));
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if genData_plotFit
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');
    cd([base_path save_path '\model_fits\' models{models2run}]);
%     load([models{models2run} '_subjectLvl_paramFits_' dists{dists2run} '.mat'])
    load([models{models2run} '_PT_' num2str(subs) '_paramFits_' dists{dists2run} '.mat']);
    %load in previously generated parameter fits
    dataFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat'];
    if ~exist(dataFilename)
        plotData = table();
        for isubject = 1: length(subs)

            trueData   = allTr_allSubjects([allTr_allSubjects.pt_number == subs(isubject)], :);
            paramFit    = data2save(data2save.ptIdx == subs(isubject), :);
            clf;
            [meanTrue(isubject, :), meanFit(isubject, :), binnedTrue(isubject, :), binnedFit(isubject, :)...
                meanAccTrue(isubject, :), meanAccFit(isubject, :), accTrue_binned{isubject}, accFit_binned{isubject}]...
                = genData_riskPref_modelComp(trueData, paramFit, models{models2run}, dists{dists2run});
            
            plotData(isubject, :) = [subs(isubject), models{models2run(imodel)}...
                                    dists{dists2run}, {{meanTrue(isubject, :)}}, {{meanFit(isubject, :)}},...
                                    cell2mat(binnedTrue(isubject, :)'), cell2mat(binnedFit(isubject, :)'),...
                                    {{meanAccTrue(isubject, :)}}, {{meanAccFit(isubject, :)}},...
                                    cell2mat(accTrue_binned(isubject)), cell2mat(accFit_binned(isubject))];

            cd([base_path save_path '\model_fits\' models{models2run} '\subjectLvl\' dists{dists2run}]);
            saveFigname = ['PT_' num2str(subs(isubject))];
            print(saveFigname, '-dpng');
        end

        % save risk preference data: TRUE and FITTED

        plotData.Properties.VariableNames = {'ptIdx', 'model', 'dist', 'meanTrue', 'meanFit', 'binnedTrue', 'binnedFit',...
            'meanAccTrue', 'meanAccFit', 'accTrue_binned', 'accFit_binned'};
        cd([base_path save_path '\model_fits\' models{models2run}]);
        saveFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat'];
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
    load([models{models2run} '_subjectLvl_paramFits_' dists{dists2run} '.mat']);

    % load in data: 1) true data and 2) generated using fitted parameters
    % generated using
    dataFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat'];
    load(dataFilename);
    paramFits = data2save;

    plotFit_riskPref(plotData, paramFits, models{models2run}, dists{dists2run});

    figSavename_1 = [models{models2run} '_' dists{dists2run} '_modelFit_riskPref'];
    figure(1);
    print(figSavename_1, '-dpng');
end