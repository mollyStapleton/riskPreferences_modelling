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
    choice_high = sum(dataIn.choice_high(trIdx) == 1)  ;  
    prop_acc(isubject) = choice_high./length(trIdx);
    if prop_acc(isubject) >= 0.65
        subs2include(isubject) = subs(isubject);
    end

end

hist(prop_acc);
axis square
xlabel('P(High|Both-Different)');
ylabel('Frequency');
set(gca, 'FontName', 'Arial')

