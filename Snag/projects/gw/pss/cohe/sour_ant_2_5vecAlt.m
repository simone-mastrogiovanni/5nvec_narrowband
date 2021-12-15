function [L0 L45 CL CR v]=sour_ant_2_5vecAlt(sour,ant)
% SOUR_ANT_2_5VEC  creates 5 from sour and ant
%                  - alternative version -
%
%    [L0 L45 CL CR v]=sour_ant_2_5vec(sour,ant)
%
%   sour, ant  structures
%   L0, L45    linear 5-vecs
%   CL, CR     circular 5-vecs
%   v          output 5-vec

% Version 2.0 - July 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

alpha=sour.a*pi/180;
del=sour.d*pi/180;
eta=sour.eta;
seta=sign(eta);
psi=sour.psi*pi/180;
a=ant.azim*pi/180;
lam=ant.lat*pi/180;
long=ant.long*pi/180;
% TH=tsid/12*pi;

a0=-(3/16)*(1+cos(2*del))*(1+cos(2*lam))*cos(2*a);
a1c=-(1/4)*sin(2*del)*sin(2*lam)*cos(2*a);
a1s=-(1/2)*sin(2*del)*cos(lam)*sin(2*a);
a2c=-(1/16)*(3-cos(2*del))*(3-cos(2*lam))*cos(2*a);
a2s=-(1/4)*(3-cos(2*del))*sin(lam)*sin(2*a);

b1c=-cos(del)*cos(lam)*sin(2*a);
b1s=(1/2)*cos(del)*sin(2*lam)*cos(2*a);
b2c=-sin(del)*sin(lam)*sin(2*a);
b2s=(1/4)*sin(del)*(3-cos(2*lam))*cos(2*a);

A(1)=(a2c+1j*a2s)/2;
A(2)=(a1c+1j*a1s)/2;
A(3)=a0;
A(4)=(a1c-1j*a1s)/2;
A(5)=(a2c-1j*a2s)/2;

B(1)=(b2c+1j*b2s)/2;
B(2)=(b1c+1j*b1s)/2;
B(3)=0;
B(4)=(b1c-1j*b1s)/2;
B(5)=(b2c-1j*b2s)/2;

L0=A;
L45=B;
CL=(A+1j*B)/sqrt(2);
CR=(A-1j*B)/sqrt(2);

keta1=sqrt(1/(1+eta^2));
keta2=sqrt(eta^2/(1+eta^2));
v=A*(keta1*cos(2*psi)-seta*1j*keta2*sin(2*psi))+B*(keta1*sin(2*psi)+seta*1j*keta2*cos(2*psi));