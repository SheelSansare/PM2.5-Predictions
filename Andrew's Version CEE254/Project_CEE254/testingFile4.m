clear
clc
close all

% load('train_test_data/separated_train_data_short_term_0_var.mat')
% load('train_test_data/separated_train_data_interpolation_0_var.mat')
% load('train_test_data/separated_train_data_long_term_0_var.mat')

problem_name = 'long_term'; %'long_term', 'short_term'
problem_type = 2; % 1, 2, 3
var_level = 0; % 0, 5, 10
train_data = load(['train_test_data/train_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).train_data; 
test_data = load(['train_test_data/test_data_',problem_name,'_',... 
num2str(var_level),'_var.mat']).test_data; 


rng(1); % reseed to 1 just in case REMOVE FOR FINAL TEST
k = 5;
c = cvpartition(size(train_data, 1),'KFold',k);
% load('test_data_short_term_5_var.mat')
averageError = 0;
groundTruthInterval = 0;
% run model for each fold and compute error
for i = 1:k
    hourly_test = sec2Hour(train_data(c.test(i), :));
    % Get the vector of predicted values
    pred_pm2d5 = pm2d5_pred_model(train_data(c.training(i), :), hourly_test, problem_type);
    accuracy = getAccuracy(pred_pm2d5, hourly_test.pm2d5);
    averageError = averageError + accuracy; %add a sum of all errors
    groundTruthInterval = groundTruthInterval + sumsqr(hourly_test.pm2d5)/length(hourly_test.pm2d5);
end
RMSE = averageError/k;
disp(['K-Fold Average RMSE: ', num2str(RMSE)]);
NRMSE = RMSE / sqrt(groundTruthInterval/k);
disp(['Normalized RMSE: ', num2str(NRMSE)]);
percentAccurate = (1-NRMSE) * 100;
disp(['Normalized Accuracy: ', num2str(round(percentAccurate, 1)), '%']);
