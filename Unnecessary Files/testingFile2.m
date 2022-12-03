clc; clear all;
%test file 2
t1=now;
% load data
load('short_term_foshan_train_val.mat')

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
    denoised = denoise(data_static{1,i},"gaussianProcess",1);
    sensorData = data_static{1, i};
    tmp=denoised;
    sensorData.pm2d5 = tmp; 
    timeNum = datenum(sensorData.time) - t;
    idx = find(timeNum<r+1 & timeNum>r); % finds the index for all values between r and r+3 to get 3 days of data
    combinedSensors = [combinedSensors; sensorData(idx,:)];
    y_original = [y_original; data_static{1,i}.pm2d5(idx,:)];
end
%% combine data for all mobile sensors (stacked ontop of eachother)
for i =1:8
    idx=[];
    denoised = denoise(data_mobile{1,i},"gaussianProcess",1);
    sensorData = data_mobile{1,i};
    tmp =denoised;
    sensorData.pm2d5 = tmp;
    timeNum = datenum(sensorData.time) - t;
    idx = find(timeNum<r+1 & timeNum>r); % finds the index for all values between r and r+3 to get 3 days of data
    combinedSensors = [combinedSensors; sensorData(idx,:)];
    y_original = [y_original; data_mobile{1,i}.pm2d5(idx,:)];
end
%% k fold cross validation
k = 5;
c = cvpartition(size(combinedSensors, 1),'KFold',k);
averageError = 0;
% run model for each fold and compute error
for i = 1:1
    problemType = 1;
    predPm2d5 = getModel(combinedSensors(c.training(i), :), combinedSensors(c.test(i), :),"gaussianProcess");
    accuracy = getAccuracy(predPm2d5, y_original(c.test(i),:));
    averageError = averageError + accuracy;
end
t2=now;
disp(accuracy) % calcualtes average error for folds
disp(t2-t1)