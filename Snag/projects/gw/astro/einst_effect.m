function [frvar,d]=einst_effect(mjd,icplot)
% EINST_EFFECT  Einstein effect as frequency variation for Earth orbit eccentricity
%   (precision about 1 day)
%
%   mjd     mjd value (days); not present: one year and plots
%
%   frvar   frequency variation factor
%   d       distance

if ~exist('mjd','var')
    mjd=57754:57754+365;
    icplot=1;
end
if ~exist('icplot','var')
    icplot=0;
end

c=299792458;
G=6.67408e-11;
MS=1.98855e30;
rs=2*G*MS/c^2;
MT=5.9726e24;
rT=6372797;
rsT=2*G*MT/c^2;
ecc=0.0167086;

aph=152100000000;
per=147095000000;
UA=149597870700;

einstSol=rs/UA;
einstEarth=rsT/rT;

JD=mjd+2400000.5;
% g=mod(357.53+0.98560028*(JD-2451545.0),360)*pi/180;
% tdb=0.001658*sin(g)+0.000014*sin(2*g);
g=mod(357.53+0.98560028*(JD-2451271.0),360)*pi/180;
d=((aph-per)/2)*(sin(g)+0.0084439*sin(2*g))+(aph+per)/2;
frvar=1-(rs./d-rs/UA);

if icplot==1
    figure,plot(d),grid on,title('distance'),xlabel('one year')
    figure,plot(frvar),grid on,title('frvar'),xlabel('one year')
end