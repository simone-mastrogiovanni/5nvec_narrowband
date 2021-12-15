function [gdps A]=sim_ps_nodop(sour,ant,t0,dt,N,ph0,icreal,t1)
%SIM_PS_NODOP  periodic source simulation without Doppler effect
%              the spin-down and position is computed only at beginning
%
%     gdps=sim_ps_nodop(sour,ant,t0,dt,N,ph0)
%
%
%  sour       source structure or 5-vect
%  ant        antenna structure (if 5-vect is input, contains frequency)
%  t0         initial time (mjd)
%  dt         sampling time (s)
%  N          number of samples
%  ph0        signal phase (deg)
%  icreal     = 1 -> real signal
%  t1         epoch for the computation of the phase (mjd; if absent, t1=t0

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ph0','var')
    ph0=0;
end

if ~exist('icreal','var')
    icreal=1;
end

if ~exist('t1','var')
    t1=t0;
end

t=(0:N-1)*dt+t0;
SF=1/86164.09053083288;

if isnumeric(sour)
    A=sour;
    fr=ant;
    stsid=0;
else
    sour=new_posfr(sour,t0);
    fr=sour.f0;

    [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,ant);
%     fprintf(' H coeff norm = %f \n',abs(Hp)^2+abs(Hc)^2)
%     fprintf('Norm L0, L45, A = %f %f %f  L0.L45 = %f\n',norm(L0),norm(L45),norm(A),dot(L0,L45))
    stsid=(gmst(t0)+(ant.long/15))*3600;
end

ph0=ph0*pi/180-(t1-t0)*86400*fr*2*pi;

s0=exp(1j*mod(fr*2*pi*t+ph0,2*pi));
gdps=0;
for i = 1:5
    gdps=gdps+A(i)*exp(1j*(i-3)*SF*2*pi*t);
end
gdps=gdps.*s0;

if icreal == 1
    gdps=real(gdps);
else
    gdps=gdps/sqrt(2);
end

gdps=gd(gdps);
gdps=edit_gd(gdps,'dx',dt);  