clc; close all hidden; clear all;
load('RW_subjectLvl_joint_paramFit.mat')
data2save_new = table();
data2save_new(:, 1) = array2table(cell2mat(data2save.ptIdx));
data2save_new(:, 2) = data2save.model;
data2save_new(:, 3) = data2save.fittedParams;
data2save_new(:, 4) = array2table(cell2mat(data2save.LL));
data2save_new(:, 5) = array2table(cell2mat(data2save.BIC));

data2save = data2save_new;
data2save.Properties.VariableNames = {'ptIdx', 'model', 'fittedParams', 'LL', 'BIC'};
save('RW_subjectLvl_joint_paramFit.mat', 'data2save')