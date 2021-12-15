function [Ap Ac]=sim_ps_st_real(sour,ant,N)
%SIM_PS_ST_REAL  periodic source low frequency modulation
%
%     [Ap Ac]=sim_ps_st_real(sour,ant,N)
%
%  sour       source structure or 5-vect
%  ant        antenna structure 
%  N          number of samples

% Version 2.0 - March 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

st=(0:N-1)*2*pi/N;

a=sour.a*pi/180;
d=sour.d*pi/180;
eta=sour.eta;
psi=sour.psi*pi/180;
seta=sign(eta);

l=ant.lat*pi/180;
long=ant.long*pi/180;
a=ant.azim*pi/180;

c2a=cos(2*a);
c2d=cos(2*d);
c2l=cos(2*l);
s2a=sin(2*a);
s2d=sin(2*d);
s2l=sin(2*l);

cd=cos(d);
cl=cos(l);
sd=sin(d);
sl=sin(l);

a0=-(3/16)*(1+c2d)*(1+c2l)*c2a;
a1c=-(1/4)*s2d*s2l*c2a;
a1s=-(1/2)*s2d*cl*s2a;
a2c=(-1/16)*(3-c2d)*(3-c2l)*c2a;
a2s=-(1/4)*(3-c2d)*sl*s2a;

b1c=-cd*cl*s2a;
b1s=+(1/2)*cd*s2l*c2a;
b2c=-sd*sl*s2a;
b2s=+(1/4)*sd*(3-c2l)*c2a;

Ap=a0+a1c*cos(st)+a1s*sin(st)+a2c*cos(2*st)+a2s*sin(2*st);
Ac=b1c*cos(st)+b1s*sin(st)+b2c*cos(2*st)+b2s*sin(2*st);