function [hourly] = sec2Hour(secData)
%% Convert the every 3 data to hourly mean data

 hourly  = retime(table2timetable(secData),'hourly','mean'); % TEMPORARY - changed hourly to minutely 
 hourly = timetable2table(hourly);
%  hourlyData = hourly{:,2};
%  hourlyTime = hourly{:,1};
 

% time = secData.time;
% date = datestr(time,'mm/dd/yyyy');
% [dayNumber,dayName] = weekday(datenum(date,'mm/dd/yyyy'));
% hour = datestr(time,'HH');
% secData = addvars(secData, date, dayName, hour,dayNumber, 'Before','time',...
%     'NewVariableNames',{'date','dayName','hour','dayNumber'});
% pm2d5_gb_date = grpstats(secData,'date','mean','DataVars','pm2d5');
% pm2d5_gb_date_datetime = datetime(cellstr(pm2d5_gb_date.date));
% pm2d5_gb_date_mean = pm2d5_gb_date.mean_pm2d5;
% data_gb_datehr = grpstats(secData,{'date','hour'},{'mean','meanci'},'DataVars',{'pm2d5','lat','lon'});
% hourlyData = data_gb_datehr.mean_pm2d5; % hourly mean pm2.5 data
% a=[];
% for i = 1:size(data_gb_datehr.date,1)
%     c= data_gb_datehr.date;
%     b=convertCharsToStrings(c(i,:));
%     a= [ a; datenum(b)];
%    
% end
% hourlyTime = a*24 + str2num(data_gb_datehr.hour);
% hourlyTime = hourlyTime-hourlyTime(1); % hourly time based on the 1st hour as 0
end