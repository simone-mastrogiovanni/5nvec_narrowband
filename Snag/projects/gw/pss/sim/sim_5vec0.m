function sig=sim_5vec(sour,ant,fr0,dt,n)
% simulation of antenna detected signal with the 5-vect
%
%   sour    source
%   ant     antenna
%   dt      sampling time
%   n       number of samples
%
%  GMST = 18.697374558 + 24.06570982441908 × D

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant);

Tsid=(24/24.06570982441908)*86400;
frsid=1/Tsid;

sig0=exp(1j*fr0*2*pi*(0:n-1)*dt);
sig=sig0*0;

for k = -2:2
    sig=sig+v(k+3)*exp(1j*(fr0+frsid*k)*2*pi*(0:n-1)*dt);
end

sig=gd(sig);
sig=edit_gd(sig,'dx',dt);