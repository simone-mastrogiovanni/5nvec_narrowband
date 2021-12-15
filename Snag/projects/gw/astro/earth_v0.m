function [alf,delt,v]=earth_v0(time,long,lat)
%EARTH_V0  computes the Earth velocity (in units of c) in a simplified way
%
%        [alf,delt,v]=earth_v0(time,long,lat)
%
%   time           serial date-time (days)
%   long,lat       detectors Earth's coordinates (degrees)
%
%     alf and delt are in radiants; v is in percentage of c
%
%      ROZZA !!

deg_to_rad=pi/180;
%c=299792458;

tsid=snag_tsid(time,long).*2.*pi;
tanno=time/365.25;
tanno=mod(tanno,1).*2.*pi;

%vrot=465.1/c;vorb=29770/c;
vrot=1.5514066e-6*cos(lat*0.01745329);
vorb=9.9302031e-5;
sineps=0.397948;coseps=0.917407;
sinlam=sin(tanno);
coslam=cos(tanno);

zo=sineps.*sinlam;
czo=sqrt(1-zo.*zo);
xo=coslam*czo;
yo=sinlam*czo;

xr=cos(tsid);
yr=sin(tsid);

x=vrot.*xr+vorb.*xo;
y=vrot.*yr+vorb.*yo;
z=vorb.*zo;

v=sqrt(x.*x+y.*y+z.*z);
alf=atan2(y,x);
delt=asin(z./v);



