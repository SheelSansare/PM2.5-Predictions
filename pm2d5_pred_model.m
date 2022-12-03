% Main File

function pred_pm2d5 = pm2d5_pred_model(trainData, testData, problemType)
    % trainData, testData is a table of combined sensor data
    % problemType is an integer representing short-term, long-term, or interpolation
    
    % seperate combined sensor data into individual sensors
    diferences = diff(trainData.time);
    idx = find(diferences<0);
    idx = [0; idx; size(trainData, 1)];
    cleanedData = [];
    for i = 1:length(idx)-1
        % fill missing data points
        firstFilledData = fillEmpty(trainData(idx(i)+1:idx(i+1),:));
        
        % Denoise 
        % 'option' is either "fourier" or the wavelet code for the mother wavelet
        % denoising, in single quotes: ' '
        option = 'db1';
 
        firstFilledData.pm2d5 = denoise(firstFilledData.pm2d5, problemType, option, 3);
        % db1 is the best for temp looking at the data plot.
        firstFilledData.tmp = denoise(firstFilledData.tmp, problemType, 'db1', 3);
        firstFilledData.hmd = denoise(firstFilledData.hmd, problemType, option, 3);
        firstFilledData.spd = denoise(firstFilledData.spd, problemType, option, 3);

        % set the gaussian process time window interval, might be good to have it different for different problems
        if problemType == 3
            timeInterval = 60; % best to keep at 60mins like the others
        else 
            timeInterval = 60;
        end

        % convert 3-second data to 60 min data
        min_filled = sec2FiveMin(firstFilledData, timeInterval);
        
        % stack sensor data
        cleanedData = [cleanedData; min_filled];
    end

    % run model with cleaned and filled data
    pred_pm2d5 = getModel(cleanedData, testData, 'gaussianProcess');
    
end
