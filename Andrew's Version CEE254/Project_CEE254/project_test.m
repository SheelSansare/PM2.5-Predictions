% This is the code from the submission instructions file, it is a sample os
% how we're going to save everything.
clear
clc
close all

% load('train_test_data/separated_train_data_short_term_0_var.mat')
% load('train_test_data/separated_train_data_interpolation_0_var.mat')
% load('train_test_data/separated_train_data_long_term_0_var.mat')

problem_name = 'long_term'; %'long_term', 'short_term'
problem_type = 2; % 1, 2, 3
var_level = 10; % 0, 5, 10
train_data = load(['train_test_data/train_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).train_data; 
test_data = load(['train_test_data/test_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).test_data; 

% Get the vector of predicted values
pred_pm2d5 = pm2d5_pred_model(train_data, test_data, problem_type);
 
% Save the vector with the nameing convention they require.
% save([problem_name,'_',num2str(var_level),'.mat'],'pred_pm2d5'); 