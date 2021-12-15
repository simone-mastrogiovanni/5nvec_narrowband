function sr=harm_sidresp_interf(sour,ant,n,typ)
%HARM_SIDRESP_INTERF  sidereal response for gravitational antennas based on
%                     harmonics analysis
%
%   ATTENTION: old epsilon definition !
%
%   ant,sour   pss structures
%   n          number of points
%   type       1 = linear, 2 = power

% Version 2.0 - September 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d2r=0.017453292519943;

A0=0.75*cos(ant.azim*d2r)*(cos(ant.lat*d2r)*cos(sour.d*d2r))^2;
A11=0.25*cos(2*ant.azim*d2r)*sin(2*ant.lat*d2r)*sin(2*sour.d*d2r);
A12=-0.5*sin(2*ant.azim*d2r)*cos(ant.lat*d2r)*sin(2*sour.d*d2r);
A21=0.0625*cos(2*ant.azim*d2r)*(3-cos(2*ant.lat*d2r))*(3-cos(2*sour.d*d2r));
A22=-0.25*sin(2*ant.azim*d2r)*sin(ant.lat*d2r)*(3-cos(2*sour.d*d2r));

B11=0.5*cos(2*ant.azim*d2r)*sin(2*ant.lat*d2r)*cos(sour.d*d2r);
B12=sin(2*ant.azim*d2r)*cos(ant.lat*d2r)*cos(sour.d*d2r);
B21=0.25*cos(2*ant.azim*d2r)*(3-cos(2*ant.lat*d2r))*sin(sour.d*d2r);
B22=sin(2*ant.azim*d2r)*sin(ant.lat*d2r)*sin(sour.d*d2r);

%A0,A11,A12,A21,A22,B11,B12,B21,B22

t=(0:(n-1))*24/n;
tt=t*6.283185307/24;
alf=sour.a*d2r;
psi=sour.psi*d2r;
eps=sour.eps;

a=A0+A11*cos(tt-alf)+A12*sin(tt-alf)+A21*cos(2*(tt-alf))+A22*sin(2*(tt-alf));
b=B12*cos(tt-alf)+B11*sin(tt-alf)+B22*cos(2*(tt-alf))+B21*sin(2*(tt-alf));

xl=a*cos(2*psi)+b*sin(2*psi);
xc=(a+j*b)/sqrt(2);

if typ == 2
    x=eps*xl.^2+(1-eps)*xc.*conj(xc);
else
    x=sqrt(eps)*xl+sqrt(1-eps)*xc;
end

sr=gd(x);
sr=edit_gd(sr,'dx',24/n);