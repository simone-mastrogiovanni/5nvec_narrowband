function y=rect_ecl2eq(x)
%RECT_ECL2EEQ  conversion between ecliptical to equatorial rectangular coordinates
%
%  x,y   3 elements array

% Version 2.0 - August 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
 

deg2rad=pi/180;
eps = -23.4392911*deg2rad; % standard epoch 2000
ceps=cos(eps);
seps=sin(eps);

y=x;
y(2)=x(2)*ceps+x(3)*seps;
y(3)=-x(2)*seps+x(3)*ceps;
