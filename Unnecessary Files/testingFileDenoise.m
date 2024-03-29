clc; clear all; close all;
% test file 2
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
    sensorData = data_static{1, i};
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
    sensorData = data_mobile{1,i};
    tmp = data_mobile{1,i};
    sensorData.pm2d5 = tmp.pm2d5;
    timeNum = datenum(sensorData.time) - t;
    idx = find(timeNum<r+1 & timeNum>r); % finds the index for all values between r and r+3 to get 3 days of data
    combinedSensors = [combinedSensors; sensorData(idx,:)];
    y_original = [y_original; data_mobile{1,i}.pm2d5(idx,:)];
end

k = 5;
c = cvpartition(size(combinedSensors, 1),'KFold',k);
averageError = 0;
% run model for each fold and compute error
for i = 1:k
    hourly_test = sec2Hour(combinedSensors(c.test(i), :));
    pred_pm2d5 = pm2d5_pred_model(combinedSensors(c.training(i), :), hourly_test);
    accuracy = getAccuracy(pred_pm2d5, hourly_test.pm2d5);
    averageError = averageError + accuracy; %add a sum of all errors
end
disp("Average RMSE:")
disp(averageError/k)

%plot results
% figure()
% plot(hourly_test.time, hourly_test.pm2d5)
% hold on 
% plot(hourly_test.time, pred_pm2d5)

% start_idx = [1];
% end_idx = [];
% test = datenum(combinedSensors(1,:).time);
% test2 = datenum(combinedSensors(2,:).time);
%for i = 1:size(combinedSensors, 1)-1
    %if (datenum(combinedSensors(i+1,:).time) < datenum(combinedSensors(i,:).time))
        %end_idx = [end_idx i];
        %start_idx = [start_idx i+1];
    %end
%end

% diferences = diff(combinedSensors.time);
% idx = find(diferences<0);
% idx = [0; idx];
% for i = 1:length(idx)-1
% 
%     firstFilledData = fillEmpty(combinedSensors(idx(i)+1:idx(i+1),:));
%     %call denoise
% end
