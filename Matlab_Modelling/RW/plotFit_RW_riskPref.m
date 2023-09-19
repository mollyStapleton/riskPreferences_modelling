function plotFit_RW_riskPref(dataIn, paramFit, dist)

    if strcmp(dist, 'Gaussian')
        col2plot = {[0.83 0.71 0.98], [0.62 0.35 0.99]};
    else 
        col2plot = {[0.58 0.99 0.56], [0.19 0.62 0.14]};
    end
    if strcmpi(dist, 'Gaussian')
        data2use = dataIn(dataIn.distType == 1, :);
    else 
        data2use = dataIn(dataIn.distType == 2, :);
    end
    
%     data2use = data2use((1:120), :);
   

    % calculate risk preference from TRUE data
    [riskyChoiceTrue, binnedRisk] = calculate_riskPref_trueData(data2use, dist);

    % simulate data fit using parameter fits 
    params.Q0 = [50 50 50 50];
    params.alpha = paramFit.alpha;
    params.beta  = paramFit.beta;

    [NegLL,choiceProb, choice_dir, Qs] = LL_RW_riskPref(data2use, paramFit.alpha, paramFit.beta);

    data2use.choiceProb = choiceProb';
    data2use.choiceL    = choice_dir';
    risky_LL = mean(data2use.choiceProb(data2use.choiceType == -1));
    risky_HH = mean(data2use.choiceProb(data2use.choiceType == 1));


%     figure(1);
%     for icnd = 1:2        
%         hold on 
%         plot([1:5], binnedRisk(icnd, :), 'color', col2plot{icnd}, 'linew', 1.2);
%         errorbar(binnedRiskFit{1, icnd}, binnedRiskFit{2, icnd}, 'color', col2plot{icnd}, 'linew', 1.2, 'lineStyle', '--');
%     end
% 
%     
end 