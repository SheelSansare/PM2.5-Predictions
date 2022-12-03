% Convert 3-second intervals into minute intervals using a mean

function [FiveMin] = sec2FiveMin(secData, timeInterval)
    % secData is a table
    % timeInterval is an integer representing minutes per interval

    FiveMin  = retime(table2timetable(secData),'regular','mean','TimeStep',minutes(timeInterval)); %  changed minute data to every 5 minutes (CHANGED TO EVERY HOUR)
    FiveMin = timetable2table(FiveMin);   % converting to a regular table
end

