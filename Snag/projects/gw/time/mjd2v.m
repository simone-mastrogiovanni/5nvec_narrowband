function [v dow doy dom]=mjd2v(mjd)
%MJD2V   converts a modified julian date to vectorial time
% 
%  dow   day of the week  (1 - Monday) 
%  doy   day of the year  (1 - 1 January)
%  dom   day of the month (1 - 1 month)

v=datevec(mjd+678942);

dow=floor(mod(mjd+3,7));
doy1=v2mjd([v(1) 1 1 0 0 0]);
doy=floor(mjd)-doy1+1;
dom1=v2mjd([v(1) v(2) 1 0 0 0]);
dom=floor(mjd)-dom1+1;