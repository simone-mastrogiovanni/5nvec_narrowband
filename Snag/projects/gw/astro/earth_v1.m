function [alf,delt,v]=earth_v1(time,long,lat,coord)
%EARTH_V1  computes the Earth velocity (in units of c) in a simplified way
%
%        [alf,delt,v]=earth_v1(time,long,lat,coord)
%
%   time           date-time (mjd)
%   long,lat       detectors Earth's coordinates (degrees)
%   coord          type of output coordinates; = 0 -> equatorial, 1 -> ecliptic
%
%     alf and delt are in radiants; v is in percentage of c
%

deg_to_rad=pi/180;

tsid=(time-v2mjd([2000 1 1 0 0 0])+(99.97+long)/360)./0.9972695667;
tsid=tsid-floor(tsid);
tsid=tsid.*2.*pi;
tanno=(time-v2mjd([2000 1 1 0 0 0]))/365.25+0.525;
tanno=mod(tanno,1)*2*pi;

vrot=1.5514066e-6*cos(lat*0.01745329);
vorb=9.9302031e-5;

if coord == 0
   sineps=0.397948;coseps=0.917407;
   sinlam=sin(tanno);
   coslam=cos(tanno);

   zo=sineps.*sinlam;
   czo=sqrt(1-zo.*zo);
   xo=coslam.*czo;
   yo=sinlam.*czo;

   xr=-sin(tsid);
   yr=cos(tsid);
   zz=zo;
   vz=vorb;
else
   xo=cos(tanno);
   yo=sin(tanno);
   
   sineps1=-0.397948; coseps=0.917407;
   sinalf=sin(tsid);
   cosalf=cos(tsid);

   zr=sineps1.*sinalf;
   czr=sqrt(1-zr.*zr);
   xr=cosalf.*czr;
   yr=sinalf.*czr;
   zz=zr;
   vz=vrot;
end   

x=vrot.*xr+vorb.*xo; 
y=vrot.*yr+vorb.*yo; 
z=vz.*zz; 

v=sqrt(x.*x+y.*y+z.*z);
alf=atan2(y,x);
delt=asin(z./v);



