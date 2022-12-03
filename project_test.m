% Testing file to save our results given final train and test data

clear; clc; close all

problem_name = 'interpolation'; %'long_term', 'short_term', 'interpolation
problem_type = 3; % 1, 2, 3
var_level = 10; % 0, 5, 10
train_data = load(['train_test_data/train_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).train_data;
test_data = load(['train_test_data/test_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).test_data; 

% Get the vector of predicted values
pred_pm2d5 = pm2d5_pred_model(train_data, test_data, problem_type);
 
% Save the vector with the nameing convention they require.
save([problem_name,'_',num2str(var_level),'.mat'],'pred_pm2d5'); 