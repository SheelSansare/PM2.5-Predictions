clc; clear all;
%test file

% load data
load('short_term_foshan_train_val.mat')

%% divide into train and test sets
% randomly select a static sensor and pull its data
rng(0); % set the seed for testing reproducibility
sensorNum = randperm(length(data_static),1);
sensorData = data_static{1,sensorNum}; % NOTE: THIS IS ONLY OPERATING ON ONE SENSOR!

% randomly select 72 hours of data
TT = table2timetable(sensorData);
TT.time.Format = "MM/dd/uuuu HH";      % getting dates and hour data
sensorData.datehr = cellstr(TT.time);   % adding column as date&hour
uniqueHour = unique(sensorData.datehr);  % get unique hours
r_ind = randperm(length(uniqueHour)-75,1);  % select one random index from all unique hours
trainHour = uniqueHour(r_ind:r_ind+71);  % the selected hours for trainData
testHour = uniqueHour(r_ind+72:r_ind+74);

% loop to get data for the test data (72 hrs) and train data (3 hrs)
% trainData = zeros(length(trainHour), 1); % also need to go back and preallocate 
trainData = [];
for i = 1:length(trainHour)
    trainData = [trainData; sensorData(find(string(sensorData.datehr) == string(trainHour(i))),:)];
end

testData = [];
for i = 1:length(testHour)
    % redo this with logical indexing eventually for performance
    testData = [testData; sensorData(find(string(sensorData.datehr) == string(testHour(i))),:)];
end

%% Call this function to train and run the model
% trainData is a table
% testData is also a table
% problemType is a categorical number
    % 1 is short-term
    % 2 is long-term
    % 3 is interpolation
problemType = 1;
predPm2d5 = pm2d5_pred_model(trainData, testData, problemType);
accuracy = getAccuracy(predPm2d5, testData.pm2d5);
disp(accuracy)