% Testing file to tune hyper parameters for model using original training set

clc; clear all; close all;
t1=now;
% load data
load('short_term_foshan_train_val.mat')
problemType = 1;
rng(1);
%% divide into train and test sets

% get 3 random days (instead of full 8 days) of data for each sensor
sensorData = data_static{1,1}; % choose one sensor for now
t = min(datenum(sensorData.time));
timeNum = datenum(sensorData.time) - t; % convert each time into datenums from 0 to 8(days)
a = max(timeNum)-3; % max for random
b = min(timeNum); % min for random
r = (b-a).*rand(1, 'double') + a; % choose a random double between 0 and 5
combinedSensors = [];
y_original =[];
%% combine data for all static sensors (stacked ontop of eachother)
for i = 1:5
    idx=[];
    % denoised = denoise(data_static{1,i},"gaussianProcess",1);
    sensorData = data_static{1, i};
%     tmp=denoised;
    tmp = data_static{1,i};
    sensorData.pm2d5 = tmp.pm2d5; 
    timeNum = datenum(sensorData.time) - t;
    idx = find(timeNum<r+1 & timeNum>r); % finds the index for all values between r and r+3 to get 3 days of data
    combinedSensors = [combinedSensors; sensorData(idx,:)];
    y_original = [y_original; data_static{1,i}.pm2d5(idx,:)];
end
%% combine data for all mobile sensors (stacked ontop of eachother)
for i =1:8
    idx=[];
    %denoised = denoise(data_mobile{1,i},"gaussianProcess",1);
    sensorData = data_mobile{1,i};
%     tmp =denoised;
    tmp = data_mobile{1,i};
    sensorData.pm2d5 = tmp.pm2d5;
    timeNum = datenum(sensorData.time) - t;
    idx = find(timeNum<r+1 & timeNum>r); % finds the index for all values between r and r+3 to get 3 days of data
    combinedSensors = [combinedSensors; sensorData(idx,:)];
    y_original = [y_original; data_mobile{1,i}.pm2d5(idx,:)];
end
% predPm2d5 = getModel(combinedSensors(c.training(i), :), combinedSensors(c.test(i), :),"gaussianProcess");

k = 5;
c = cvpartition(size(combinedSensors, 1),'KFold',k);
% load('test_data_short_term_5_var.mat')
averageError = 0;
groundTruthInterval = 0; %Tarjei - NRMSE
% run model for each fold and compute error
for i = 1:k
    hourly_test = sec2Hour(combinedSensors(c.test(i), :));
    pred_pm2d5 = pm2d5_pred_model(combinedSensors(c.training(i), :), hourly_test);
    accuracy = getAccuracy(pred_pm2d5, hourly_test.pm2d5);
    averageError = averageError + accuracy; %add a sum of all errors
    groundTruthInterval = groundTruthInterval + sumsqr(hourly_test.pm2d5)/length(hourly_test.pm2d5); %Tarjei - NRMSE
end
disp("Average RMSE:")
disp(averageError/k)

NRMSE = (averageError/k)/sqrt(groundTruthInterval/k); %Tarjei - NRMSE
disp("Average NRMSE:")
disp(NRMSE)


%plot results
% figure()
% plot(hourly_test.time, hourly_test.pm2d5)
% hold on 
% plot(hourly_test.time, pred_pm2d5)


