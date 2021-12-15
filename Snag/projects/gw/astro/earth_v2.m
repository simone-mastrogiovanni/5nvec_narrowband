function [alf,delt,v,vv,vo,vr]=earth_v2(time,long,lat)
%EARTH_V2  computes the Earth velocity (in units of c) with higher
%          precision than earth_v1
%
%        [alf,delt,v,vv,vo,vr]=earth_v2(time,long,lat)
%
%   time           date-time (mjd)
%   long,lat       detectors Earth's coordinates (degrees)
%
%     ATTENTION ! alf and delt are in RADIANTS; v is in percentage of c
%     vv(n,3) is the equatorial rectangular coordinates matrix 

% Version 2.0 - November 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome


tsid=(time-v2mjd([2000 1 1 0 0 0])+(99.97+long)/360)./0.9972695667;
tsid=tsid-floor(tsid);
tsid=tsid.*2.*pi;
% tanno=(time-v2mjd([2000 1 1 0 0 0]))/365.25+0.525;
% tanno=mod(tanno,1)*2*pi;

vrot=1.5514066e-6*cos(lat*0.01745329);
JD=time+2400000.5;

EarthVel=earth_vel_ron_vondrak(JD);
AU=149597870700; % m
c_=299792458;    % m/s
vo=EarthVel*AU/(c_*86400);

% xo=vo(:,1);
% yo=vo(:,2);
% zo=vo(:,3);

vr(:,1)=-vrot.*sin(tsid);
vr(:,2)=vrot.*cos(tsid);
vr(:,3)=time*0;

vv=vo+vr;

x=vv(:,1); 
y=vv(:,2); 
z=vv(:,3);

% if coord == 1
%     for i = 1:length(time)
%         veq=[x(i) y(i) z(i)];
%         vecl=rect_eq2ecl(veq);
%         x(i)=vecl(1);
%         y(i)=vecl(2);
%         z(i)=vecl(3);
%     end
% end

v=sqrt(x.*x+y.*y+z.*z);
alf=atan2(y,x);
delt=asin(z./v);