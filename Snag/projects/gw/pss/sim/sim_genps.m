function [sig,outphase,frt]=sim_genps(sour,ant,dt,n,inphase,initime)
% simulation of general periodic signal
%
%   sour     source structure
%            basic:
%                  a       right ascension (deg)
%                  d       declination
%                  v_a     velocity r.a. component (marcs/y)
%                  v_d     velocity dec component  (marcs/y)
%                  pepoch  position epoch
%                  f0      gravitational frequency  (Hz)
%                  df0     f0 derivative (Hz/s); if array, also superior order derivatives
%                  ddf0    sf0 econd derivative (if df0 is not an array)
%                  fepoch  frequency epoch
%                  eta
%                  psi
%                  h       wave amplitude (out of the antenna)
%            binary parameters:  (if binary)
%                  bin.P      orbital period (s)
%                  bin.asini  projection of semi major axis along the line of sight (s)
%                  bin.ecc    orbital eccentricity
%                  bin.omega  periapse passage angle (deg)
%                  bin.tp     time of periapse passage (s)
%                  bin.dP     period derivative (s/s)
%                  bin.Pepoch eriod epoch
%            secondary:
%                  ecl     ecliptical coordinates [lambda beta] (deg)
%                  t00
%                  snr
%                  chphase
%                  dfrsim  freq shift for simulation (Hz)
%   ant      antenna
%   dt       sampling time
%   n        number of samples
%   inphase  input phases: inphase(1) inisid  beginning Greenwich sidereal hour
%                          inphase(2) ph0     signal phase (degrees) 
%                          inphase(3) argbin  orbital phase (for binaries)
%   initime  starting time (mjd, only for first chunk, absent for subsequent chunks)
%
%  GMST = 18.697374558 + 24.06570982441908 × D

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.090530833; % at epoch2000
Tsidfact=Tsid/86400;

frsid=1/Tsid;
inisid=0;
inisid1=(inisid-sour.a/15+ant.long/15)*3600*Tsidfact;  % CONTROLLARE

inisid=inphase(1);
ph0=inphase(2);
argbin=inphase(3);

fr0=sour.f0;
dfr0=sour.df0;
if length(dfr0) == 1
    dfr0(2)=sour.ddf0;
end

% starting signal
sig0=exp(1j*(fr0*2*pi*(0:n-1)*dt+ph0*pi/180));

% frequency modification
frt=zeros(1,n);

% spin-down
nord=length(dfr0);
fac=1;

for i = 1:nord
    fac=fac*i;
    frt=frt+(dfr0(i)*((0:n-1)*dt).^i)/fac;
end

% binary doppler
if isfield(sour,'bin')
    frt=binary_doppler(sour,frt,fr0);
end

% terrestrial doppler
%frt=frt_doppler(sour,ant,frt,fr0);

% signal at the detector
ph=cumsum(frt)*dt*2*pi;
corr=exp(-1j*ph);
sig0=sig0.*corr;

% signal in the detector (5-vect)
[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant);

sig=sig0*0;

for k = -2:2
    bb=(frsid*k)*2*pi*((0:n-1)*dt+inisid1);
    aa=exp(1j*bb);
    sig=sig+v(k+3)*aa.*sig0;
end

if exist('initime','var')
    inisid=gmst(initime);
end

outsid=inisid+(n*dt/Tsid)*24;
frsid=1/Tsid;
inisid1=(inisid-sour.a/15+ant.long/15)*3600*Tsidfact;  % CONTROLLARE

phout=mod(ph0+fr0*360*n*dt,360);
outphase=0;