function [FiveMin] = sec2FiveMin(secData)
% This function really needs a description for what it's supposed to be
% taking in and then returning, and in what format.
% NOTE IT ACTUALLY RETURNS AN HOUR NOT 5 MINS AS THE NAME WOULD IMPLY

    FiveMin  = retime(table2timetable(secData),'regular','mean','TimeStep',minutes(60)); %  changed minute data to every 5 minutes 
    FiveMin = timetable2table(FiveMin);   % converting to a regular table

end

