function [f,z,w,p,wz,sinfi,cos2fi]=angr85A(bar_ant,source,tsid)
%ANGR85  bar antenna response to a source
%
%   ATTENTION: old epsilon definition !
%
%   bar_ant   bar antenna structure
%          .long   longitude (degrees)
%          .lat    latitude      "
%          .azim   azimuth       "    (from south to west)
%          .incl   inclination        "
%
%   source
%         .a       right ascension
%         .d       declination
%         .eps     linear polarization percentage
%         .psi     polarization angle
%   
%   tsid     sidereal time (in degrees)
%

% From ADES (SF, 1985)

% Version 1.0 - December 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

conv=pi/180;

alf=source.a*conv;
delt=source.d*conv;
eps=source.eps;
psi=source.psi*conv;

long=bar_ant.long*conv;
lat=bar_ant.lat*conv;
ro=bar_ant.azim*conv;
if ro == 0
    ro=0.000001;
end
ts=tsid*conv;

sinh=sin(bar_ant.incl*conv);
cosh=cos(bar_ant.incl*conv);

sina=sin(ro);
cosa=cos(ro);

sinfi=sin(lat);
cosfi=cos(lat);

angor=atan2(cosh.*sina,cosfi.*sinh+sinfi.*cosh.*cosa);
deltz=atan2(sinfi.*sinh-cosfi.*cosh.*cosa,cosh.*sina./sin(angor));

z3=sin(deltz);
cz=cos(deltz);
alfz=ts-angor+long;
z1=cz.*cos(alfz);
z2=cz.*sin(alfz);
z(1,:)=z1;
z(2,:)=z2;
z(3,:)=z3;
cdel=cos(delt);
w1=cdel.*cos(alf);
w2=cdel.*sin(alf);
w3=sin(delt);
w=[w1,w2,w3];
f=.5;
costet=w1.*z1+w2.*z2+w3.*z3;
sin4tet=(1-costet.*costet).^2;

if eps > 0.001
    wz1=w2.*z3-w3.*z2;
    wz2=w3.*z1-w1.*z3;
    wz3=w1.*z2-w2.*z1;
    wz(1,:)=wz1;
    wz(2,:)=wz2;
    wz(3,:)=wz3;
    awz=sqrt(wz1.*wz1+wz2.*wz2+wz3.*wz3);
    deltp=asin(cos(psi).*cos(delt));
    alfp=alf+acos(-tan(delt).*tan(deltp));
    cdelp=cos(deltp);
    p1=cdelp.*cos(alfp);
    p2=cdelp.*sin(alfp);
    p3=sin(deltp);
    p=[p1,p2,p3];
    sinfi=(p1*wz1+p2*wz2+p3*wz3)./awz;size(wz1),size(sinfi)
    cos2fi=(1-2*sinfi.*sinfi).^2;
    f=.5*(1-eps)+eps.*cos2fi;
end

f=f.*sin4tet;