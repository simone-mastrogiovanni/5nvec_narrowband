function [sig,outsid,phout]=sim_5vec(sour,ant,inisid,ph0,dt,n)
% simulation of antenna detected signal with the 5-vect
%
%   sour    source
%   ant     antenna
%   inisid  beginning Greenwich sidereal hour
%   ph0     phase (degrees)
%   dt      sampling time
%   n       number of samples
%
%  GMST = 18.697374558 + 24.06570982441908 × D

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

% Tsid=(24/24.06570982441908)*86400;
Tsid=86164.090530833; % at epoch2000
Tsidfact=Tsid/86400;
outsid=inisid+(n*dt/Tsid)*24;

[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant);

frsid=1/Tsid;
inisid1=(inisid-sour.a/15+ant.long/15)*3600*Tsidfact;  % CONTROLLARE

fr0=sour.f0;
phout=mod(ph0+fr0*360*n*dt,360);

sig0=exp(1j*(fr0*2*pi*(0:n-1)*dt+ph0*pi/180));
sig=sig0*0;

for k = -2:2
    bb=(frsid*k)*2*pi*((0:n-1)*dt+inisid1);
    aa=exp(1j*bb);
    sig=sig+v(k+3)*aa.*sig0;
end

sig=gd(sig);
sig=edit_gd(sig,'dx',dt);