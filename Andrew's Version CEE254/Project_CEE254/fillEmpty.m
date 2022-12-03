function filledData = fillEmpty(trainData)
% FILLEMPTY takes in an uncleaned table, TRAINDATA, and retimes the 
% timestamps to be every three seconds, as well as filling missing values
% where they may occur. The resulting table is filled, but not denoised.


% extract time and pm2d5 data from trainData
TT1 = table(trainData.time, trainData.pm2d5, trainData.hmd,...
    trainData.spd, trainData.tmp, trainData.lat, trainData.lon, ...
    'VariableNames',{'time','pm2d5', 'hmd', 'spd', 'tmp', 'lat', 'lon'});

% intermediate step: convert table to timetable so that we can use retime
TT = table2timetable(TT1);

% resample the 3-second data to minutely data by taking averages
% note: if the 3-second data is missing for a minute, this function will flag it
% as NaN
% TT2 = retime(TT1,"minutely","mean");

% (Andrew) I commented out the above line to implement the following line
% that will return the filled data table with regular 3-second intervals.
TT2 = retime(TT, 'regular', 'linear', 'TimeStep', seconds(3));
% fill missing data(NaN) with the available previous data
filledData = fillmissing(TT2,"linear");
filledData = timetable2table(filledData);
end
