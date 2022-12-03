function [hourlyData,hourlyTime] = min2Hour(minData)
% This function really needs a description for what it's supposed to be
% taking in and then returning, and in what format.
    hourly  = retime(table2timetable(minData),'minutely','mean'); % TEMPORARY - changed hourly to minutely 
    hourly = timetable2table(hourly);
    hourlyData = hourly{:,2};
    hourlyTime = hourly{:,1};
end

