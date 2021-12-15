function doy=day2doy(day,month,year)
%DAY2DOY   conversion from day time to doy time
%
%   day time has 6 components
%   doy time has 5 components

doy=day;

for i = 1:month-1
   doy=doy+eomday(year,i);
end

