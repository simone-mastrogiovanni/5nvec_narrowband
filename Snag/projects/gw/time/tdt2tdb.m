function tdb=tdt2tdb(mjd)
% TDT2TDB  seconds to add to tdt (terrestrial dymamical time (TAI corrected)) 
%          to have tdb (barycentric dynamical time)
%
%   mjd   mjd value (days)
%
%   tdb   seconds to add to the tdt

JD=mjd+2400000.5;
g=mod(357.53+0.98560028*(JD-2451545.0),360)*pi/180;
tdb=0.001658*sin(g)+0.000014*sin(2*g);
