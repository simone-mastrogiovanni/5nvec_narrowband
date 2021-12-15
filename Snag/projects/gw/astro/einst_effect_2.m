function [frvar,d]=einst_effect_2(mjd)
% EINST_EFFECT  Einstein effect as frequency variation for Earth orbit eccentricity
%   (precision about 1 day)
%
%   mjd     mjd value (days); not present: one year and plots
%
%   frvar   frequency variation factor
%   d       distance

icplot=0
if ~exist('mjd','var')
    mjd=57754:57754+365;
    icplot=1;
end

c=299792458;
G=6.67408e-11;
MS=1.98855e30;
rs=2*G*MS/c^2;
MT=5.9726e24;
rT=6372797;
rsT=2*G*MT/c^2;

aph=152100000000;
per=147095000000;
UA=149597870700;

ecc=0.0167086;
sma=UA*1.000001018;

% [rr,vv,NN,r,theta,dtheta]=base_elliptic_orbit(ecc,sma,200);
I200=200;
dT=365.2421/I200;
T=(0:I200)*dT;
[Nu,R,E,Vel,M]=kepler_elliptic_ofek(T,per/UA,ecc);
r=R*UA;
degthet=M*180/pi;

JD=mjd+2400000.5;
degt=mod(357.53+90+0.98560028*(JD-2451271.0),360);
d=spline(degthet,r,degt);
% frvar=1-(rs./d-rs/UA);
frvar=1-(rs./d-rs/UA);

if icplot==1
    figure,plot(d),grid on,title('distance'),xlabel('one year')
    figure,plot(frvar),grid on,title('frvar'),xlabel('one year')
end