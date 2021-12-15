function [h lf]=basic_resp_ant(sour,ant,nsid)
%BASIC_RESP_ANT 
%
%   [h lf h1]=basic_resp_ant(sour,ant,nsid);
%
%  sour,ant   source and antenna structure
%  nsid       number of sidereal days

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

t0=v2mjd([2007 9 1 0 0 0]);
sour=new_posfr(sour,t0);

del=sour.d*pi/180;
lam=ant.lat*pi/180;
a=ant.azim*pi/180;
eps=sour.eps;
psi=sour.psi;
fi=2*psi*pi/180;

a0=-(3/16)*(1+cos(2*del))*(1+cos(2*lam))*cos(2*a);
a1c=-(1/4)*sin(2*del)*sin(2*lam)*cos(2*a);
a1s=(1/2)*sin(2*del)*cos(lam)*sin(2*a);
a2c=-(1/16)*(3-cos(2*del))*(3-cos(2*lam))*cos(2*a);
a2s=(1/4)*(3-cos(2*del))*sin(lam)*sin(2*a);

b1c=-cos(del)*cos(lam)*sin(2*a);
b1s=-(1/2)*cos(del)*sin(2*lam)*cos(2*a);
b2c=-sin(del)*sin(lam)*sin(2*a);
b2s=-(1/4)*sin(del)*(3-cos(2*lam))*cos(2*a);

t=0:0.001:2*pi*nsid;
tt=t*100;
AA1=a1c*cos(t)+a1s*sin(t);
AA2=a2c*cos(2*t)+a2s*sin(2*t);
AAA=a0+AA1+AA2;
BB1=b1c*cos(t)+b1s*sin(t);
BB2=b2c*cos(2*t)+b2s*sin(2*t);
BBB=BB1+BB2;

ctt=cos(tt);
stt=sin(tt);

ka=(eps+sqrt(2-eps.^2))/2;
kb=sqrt(1-ka^2);

HA=ka*cos(fi)*ctt-kb*sin(fi)*stt;
HB=ka*sin(fi)*ctt+kb*cos(fi)*stt;

h=AAA.*HA+BBB.*HB;
% lf=sqrt((ka*cos(fi))^2+(kb*sin(fi))^2)*AAA+sqrt((ka*sin(fi))^2+(kb*cos(fi))^2)*BBB;
lf=(ka*cos(fi)+kb*sin(fi))*AAA+(ka*sin(fi)+kb*cos(fi))*BBB;
