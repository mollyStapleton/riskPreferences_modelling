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

    % whether parameter fits have been generated separately for each
    % reward distribuion or not
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');

%     p = gcp('nocreate');
%     if ~isempty(p)
%         Nwork = p.NumWorkers;
%     else
%         Nwork = 0;
%     end
%     if Nwork ~= 4
%         delete(gcp('nocreate'))
%         %   parpool('local', 4, 'IdleTimeout', 30);
%         parpool('local', 4);
%     end
    data2save  = table();

    if distSplit == 0

        for isubject = 1: length(subs)
            data2run    = []; 
            trIdx       = find(allTr_allSubjects.pt_number == subs(isubject));
            data2run    = allTr_allSubjects(trIdx, [1:10 16]);
            [best_fit_parm(isubject, :), LL(isubject), BIC(isubject)] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists, dists2run, nIters);
            data2save(isubject, :) = [subs(isubject) models{models2run(imodel)},...
                {best_fit_parm(isubject, :)} LL(isubject) BIC(isubject)];
        end

        saveTablename = [models{models2run} '_subjectLvl_joint_paramFit.mat'];
        data2save.Properties.VariableNames = {'ptIdx', 'model','fittedParams', 'LL', 'BIC'};
        
    else 

        for idist = 1: length(dists2run)
            
            %load in distribution relevant data 
            
                if strcmpi(dists{dists2run(idist)}, 'Gaussian')
                    distIdx = 1;
                else
                    distIdx = 2;
                end   
         for isubject = 1: length(subs)
            data2run    = []; 
            trIdx       = find(allTr_allSubject.distType == distIdx & allTr_allSubjects.pt_number == subs(isubject));
            data2run    = allTr_allSubjects(trIdx, [1:10 16]);
            [best_fit_parm(isubject, :), LL(isubject), BIC(isubject)] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists, dists2run, nIters);
            %             [best_fit_parm, LL, BIC] = modelFitting_riskPref(data2run, models{models2run(imodel)}, params, dists, dists2run, nIters);
            data2save(isubject, :) = [subs(isubject) models{models2run(imodel)},...
                dists{dists2run(idist)} {best_fit_parm(isubject, :)} LL(isubject) BIC(isubject)];
         end

            saveTablename = [models{models2run} '_subjectLvl_paramFit_' dists{dists2run(idist)} '.mat'];
            data2save.Properties.VariableNames = {'ptIdx', 'model', 'dist', 'fittedParams', 'LL', 'BIC'};
        end

    end

        
        cd([base_path save_path '\model_fits\' models{models2run}]);
        save( saveTablename, 'data2save');

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if genData_plotFit
    cd([base_path data_path]);
    load('allTr_allSubjects.mat');
    cd([base_path save_path '\model_fits\' models{models2run}]);
    if dists2run ~= 3
        load([models{models2run} '_subjectLvl_paramFits_' dists{dists2run} '.mat']);
        dataFilename = ['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat'];
    else
        load([models{models2run} '_subjectLvl_joint_paramFit.mat']);
        dataFilename = ['dataPlot_truevsfit_' models{models2run} '_jointParamFit.mat'];
      
    end

    if ~exist(dataFilename)

        plotData = table();

        for isubject = 1: length(subs)

            trueData   = allTr_allSubjects([allTr_allSubjects.pt_number == subs(isubject)], :);
            paramFit    = data2save(data2save.ptIdx == subs(isubject), :);
            clf;
            
            data2plot(isubject) = genData_riskPref_modelComp(trueData, paramFit, models{models2run}, dists{dists2run});

            if dists2run == 3
                tmpData = table();
                nDist   = 2;
                distIdx = [1 2];
            else
                nDist   = 1;
                distIdx = dists2run;
            end
            for idist = 1:nDist
                tmpData(idist, :) = [subs(isubject), models{models2run(imodel)}...
                    distIdx(idist), {data2plot(isubject).meanTrue(idist, :)}...
                    {data2plot(isubject).meanFit(idist, :)}, {data2plot(isubject).binnedTrue{idist}}...
                    {data2plot(isubject).binnedFit{idist}}, {data2plot(isubject).accTrue(idist, :)}...
                    {data2plot(isubject).accFit(idist, :)}, {data2plot(isubject).accTrue_binned{idist}}...
                    {data2plot(isubject).accFit_binned{idist}}];
            end
            
            plotData = [plotData; tmpData];
            cd([base_path save_path '\model_fits\' models{models2run} '\subjectLvl\' dists{dists2run}]);
            saveFigname = ['PT_' num2str(subs(isubject)) '_jointParamFit'];
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
    if dists2run ~= 3
        load([models{models2run} '_subjectLvl_paramFits_' dists{dists2run} '.mat']);
        load(['dataPlot_truevsfit_' models{models2run} '_' dists{dists2run} '.mat']);
        distIdx = dists2run;
        fitType = 'Separate Parameters';
   
    else
        load([models{models2run} '_subjectLvl_joint_paramFit.mat']);
        load(['dataPlot_truevsfit_' models{models2run} '_Joint.mat']);
        distIdx = [1 2];
        fitType = 'Joint Parameters';
    end

    
    paramFits = data2save;

    for idist = 1: length(distIdx)
      data2plot = [];
      data2plot = plotData(plotData.dist == distIdx(idist), :);
      plotFit_riskPref(data2plot, paramFits, models{models2run}, dists{distIdx(idist)}, fitType);

      if dists2run ~= 3 
          figSavename_1 = ['average_' models{models2run} '_' dists{dists2run} '_modelFit_riskPref'];
      else 
          figSavename_1 = ['average_' models{models2run} '_joint_' dists{distIdx(idist)} '_modelFit_riskPref'];
      end

      figure(1);
      print(figSavename_1, '-dpng');
    end
        

end