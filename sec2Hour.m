% Convert the every 3-second data to hourly mean data

function [hourly] = sec2Hour(secData)
    % secData is a table

    hourly  = retime(table2timetable(secData),'hourly','mean'); 
    hourly = timetable2table(hourly);
end