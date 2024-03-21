clc; close all hidden; clear all;
%-------------------------------------------------------
% PATH SETTING
%-------------------------------------------------------
base_path = ['C:\Users\jf22662\OneDrive - University of Bristol\Documents\GitHub\'];
repo_path = ['riskPreferences_modelling\Matlab_Modelling\']
data_path = ['data'];cd([base_path data_path]);
load('allTr_allSubjects.mat');
dataIn = allTr_allSubjects;
subs = unique(dataIn.pt_number);
subs2include = nan(1, length(subs));

for isubject = 1: length(subs)
    trIdx = [];
    trIdx = find(dataIn.pt_number == subs(isubject) & dataIn.distType == 1 & dataIn.cnd_idx == 1);
    choice_high = sum(dataIn.choice_high(trIdx) == 1);
    stat_acc(isubject) = binocdf(choice_high, 160, 0.5);
    stat_acc(isubject) = 1- stat_acc(isubject);
    prop_acc(isubject) = choice_high./length(trIdx);
   
    if stat_acc(isubject) < 0.05
        subs2include(isubject) = subs(isubject);
        mkrFace                = [0.7059 0.4745 0.9882];
    else 
         mkrFace                = [1 1 1];
%     [~, sig_acc(isubject), ~, ~] = ttest(prop_acc(isubject), 0.5); 
    end

%     trIdx = [];
%     trIdx = find(dataIn.pt_number == subs(isubject) & dataIn.distType == 1 & dataIn.cnd_idx == 3);
%     choice_risk = sum(dataIn.choice_risky(trIdx) == 1)  ;  
%     prop_risk(isubject) = choice_risk./length(trIdx);
    subplot(1, 2, 2);
    hold on
    plot(isubject, prop_acc(isubject), 'o', 'MarkerFaceColor', mkrFace, 'MarkerEdgeColor', [0.7059 0.4745 0.9882],...
        'linew', 1.5, 'MarkerSize', 7);
    axis square
    hold on
    box on
    plot([0 35], [0.5 0.5], 'k--');
    xlabel('Participant No.'); 
    ylabel('P(High|Both-Different)')
    set(gca, 'FontName', 'Arial')
    xlim([0 35]);
end


figure(1);
subplot(1, 2, 1)
hist(prop_acc);
xlim([0 1])
axis square
xlabel('P(High|Both-Different)');
ylabel('Frequency');
set(gca, 'FontName', 'Arial')

cd(base_path);
set(gcf, 'position', [488 437.8000 988.2000 324.2000])
saveFigname = 'criteria_subjectInclusion';
print(saveFigname, '-dsvg');

for isubject = 1: length(subs)
    trIdx = [];
    trIdx = find(dataIn.pt_number == subs(isubject) & dataIn.distType == 2 & dataIn.cnd_idx == 1);
    choice_high = sum(dataIn.choice_high(trIdx) == 1);
    stat_acc(isubject) = binocdf(choice_high, 160, 0.5);
    stat_acc(isubject) = 1- stat_acc(isubject);
    prop_acc(isubject) = choice_high./length(trIdx);
   
end
figure(2);
subplot(1, 2, 1)
hist(prop_acc);
xlim([0 1])
axis square
xlabel('P(High|Both-Different)');
ylabel('Frequency');
set(gca, 'FontName', 'Arial')
cd(base_path);
set(gcf, 'position', [488 437.8000 988.2000 324.2000])
saveFigname = 'criteria_subjectInclusion_bimodalHist';
print(saveFigname, '-dsvg');