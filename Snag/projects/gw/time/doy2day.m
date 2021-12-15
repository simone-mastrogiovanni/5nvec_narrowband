function [day,month]=doy2day(doy,year)
%DOY2DAY   conversion from doy time to day time
%
%   day time has 6 components
%   doy time has 5 components

tdoy=doy;
month=0;

while tdoy > 0
   month=month+1;
   day=tdoy;
   tdoy=tdoy-eomday(year,month);
end
