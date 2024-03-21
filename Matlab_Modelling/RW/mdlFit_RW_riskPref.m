function [best_fit_parm, LL, BIC] = mdlFit_RW_riskPref(dataIn_all, params, dist, dists2run, nIters)

%-------------------------------------------------------------------
%%% RW model fit to risk preferences 
%---------------------------------------------------------------------
%%% TRUE DATA NEEDED:
%%% 1) Stimulus LEFT 
%%% 2) Stimulus RIGHT 
%%% 3) Choice made 
%%% 4) reward obtained
%--------------------------------------------------------------------------

%     if strcmpi(dist{dists2run(idist)}, 'Gaussian')
%         distType = 1;
%     else
%         distType = 2;
%     end
%     
%     distIdx     = find(dataIn_full.distType == distType);
%     dataIn_all  = dataIn_full(distIdx, :);
%     
    % objective function uses real data to fit using parameters alpha and beta
    % returned in X0
    % generation of an anonymous function
    % @(x) defines the input of the function
    % function inputs (dataIn, alpha, beta)
    
    obFunc = @(x) LL_RW_riskPref(dataIn_all, x(1), x(2));
    LB = [0 0];
    UB = [1 3];
    % return set of parameters to be fit (alpha and beta for RW model)
    for iter = 1:nIters
        X0(iter,:) = [params.alpha(iter) params.beta(iter)];
    end
    
    % setting for optimization function
    feval = [50000, 50000]; % max number of function evaluations and iterations
    options = optimoptions(@fmincon, 'StepTolerance', 1e-6,...
        'ConstraintTolerance', 1e-6, 'MaxFunEvals',feval(1),'MaxIter',feval(2),...
        'Display','none');
    %     options = optimset('MaxFunEvals',feval(1),'MaxIter',feval(2), 'TolFun', 1e-6,...
    %         'TolX', 1e-6, 'Display','iter');
    
    for iter = 1:nIters
        %     parfor iter = 1:nIters
        %         [Xfit_grid(iter,:), NegLL_grid(iter)] = fminsearchbnd(obFunc, X0(iter,:), LB, UB, options);
        [Xfit_grid(iter,:), NegLL_grid(iter, 1)] = fmincon(obFunc,X0(iter,:),[],[],[],[],LB,UB,[],options);
    end
    
    [~,best] = min(NegLL_grid);
    best_fit_parm = Xfit_grid(best,:);
    NegLL = NegLL_grid(best);
    
    LL = -NegLL;
    % nParams * log(nObs) + 2 * NegLL
    BIC = length(X0(1,:)) * log(size(dataIn_all, 1)) + 2*NegLL;
end

