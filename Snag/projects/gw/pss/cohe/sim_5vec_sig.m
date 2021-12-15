function [sig,v5t,fr_noal]=sim_5vec_sig(N,dt,t0,sour,ant)
% basic simulation of 5-vect signal (no doppler, no spin-down)
%
%    [sig,v5t]=sim_5vec_sig(N,dt,t0,sour,ant)
%
%   N        number of samples
%   dt       sampling time
%   t0       initial time (mjd)
%   sour,ant source and antenna structures

% Snag version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

FS=1/86164.09053083288;
Dfr=(-2:2)*FS;

fr0=sour.f0;
fr_noal=fr0;
if fr0*dt >= 1
    disp(' *** Aliased signal !')
    sf=1/dt;
    nb=floor(fr0/sf);
    fr_noal=fr0-nb*sf;
end

[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant,1);
v5t=v;

[t,t1,t2]=t_culm(ant.long,sour.a,t0)
t=(0:N-1)*dt+(t0-t1)*86400;

sig=t*0;

fr=fr0+Dfr;

for k = 1:5
    bb=fr(k)*2*pi*t;
    aa=exp(1j*bb);
    sig=sig+v(k)*aa;
end

sig=gd(sig);
cont.t0=t0;
cont.fr0=fr0;
cont.fr_noal=fr_noal;
bandw=1/dt;
inifr=floor(fr0/bandw)*bandw;
cont.inifr=inifr;
cont.bandw=bandw;
cont.ant=ant.name;
sig=edit_gd(sig,'dx',dt,'cont',cont);