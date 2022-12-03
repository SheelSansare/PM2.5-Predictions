function pred_pm2d5 = pm2d5_pred_model(trainData, testData, problemType)
    %% Main File

    % train data is a vector of two sub tables. One table of static sensors
    % and one table of mobile sensors stacked on top of eachother

    % Combine static and mobile data
%     trainData = [trainData{1,1}; trainData{1,2}]; %UNCOMMENT THIS WHEN
    %RUNNING FINAL

    % Split combined data into individual sensor data
    diferences = diff(trainData.time);
    idx = find(diferences<0);
    idx = [0; idx; size(trainData, 1)];
    cleanedData = [];
    for i = 1:length(idx)-1

        firstFilledData = fillEmpty(trainData(idx(i)+1:idx(i+1),:));
       
        % Denoise the retimed data.
        % 'option' is either "fourier" the wavelet code for the mother wavelet
        % denoising, in single quotes: ' '
        option = 'db1';

        problemType = 1; % HARDCODED PROBLEM TYPE HERE - REMOVE IF NEEDED 

        firstFilledData.pm2d5 = denoise(firstFilledData.pm2d5, problemType, option, 5);
        % db1 is the best for temp, need to confirm 5 is the right level to go to.
        firstFilledData.tmp = denoise(firstFilledData.tmp, problemType, 'db1', 5); % not using temp in final model
        firstFilledData.hmd = denoise(firstFilledData.hmd, problemType, 'db1', 5);
        firstFilledData.spd = denoise(firstFilledData.spd, problemType, 'db1', 5);

        % Convert 3 second data to hourly data
        min_filled = sec2FiveMin(firstFilledData);
        cleanedData = [cleanedData; min_filled];
    end

    % run model with cleaned and filled data
    pred_pm2d5 = getModel(cleanedData, testData, 'gaussianProcess');
end
