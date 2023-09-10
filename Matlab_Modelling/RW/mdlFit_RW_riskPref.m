function [best_fit_parm, LL, BIC] = mdlFit_RW_riskPref(dataIn, params, dist, distSplit, nIters)

%-------------------------------------------------------------------
%%% RW model fit to risk preferences 
%---------------------------------------------------------------------
%%% TRUE DATA NEEDED:
%%% 1) Stimulus LEFT 
%%% 2) Stimulus RIGHT 
%%% 3) Choice made 
%%% 4) reward obtained
%--------------------------------------------------------------------------

% if model fitting to be split by reward distribution, identify
% distribution specific trials
if distSplit 
    if strcmpi(dist, 'Gaussian')
        distType = 1; 
    else 
        distType = 2;
    end

    distIdx = find(dataIn.distType == distType);
    dataIn  = dataIn(distIdx, :);
end 

    % objective function uses real data to fit using parameters alpha and beta
    % returned in X0
    % generation of an anonymous function
    % @(x) defines the input of the function
    % function inputs (dataIn, alpha, beta)

    obFunc = @(x) LL_RW_riskPref(dataIn, x(1), x(2));
    LB = [0 1];
    UB = [1 inf];
    % return set of parameters to be fit (alpha and beta for RW model)
    for iter = 1:nIters
        X0(iter,:) = [params.alpha(iter) params.beta(iter)];
    end
    
    % setting for optimization function
    feval = [50000, 50000]; % max number of function evaluations and iterations
    options = optimset('MaxFunEvals',feval(1),'MaxIter',feval(2),'TolFun',1e-10,'TolX',...
         1e-10, 'TolCon', 1e-10, 'Display','none');
    
        for iter = 1:nIters
            %     parfor iter = 1:Nfit
             [Xfit_grid(iter,:), NegLL_grid(iter)] = fminsearchbnd(obFunc, X0(iter,:), [], [], options);
        end

    [~,best] = min(NegLL_grid);
    Xfit = Xfit_grid(best,:);
    NegLL = NegLL_grid(best);

    LL = -NegLL;
    BIC = length(X0(1,:)) * log(size(dataIn, 1)) + 2*NegLL;

end