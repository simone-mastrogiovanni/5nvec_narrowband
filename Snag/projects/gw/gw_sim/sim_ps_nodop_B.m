function [gdps A]=sim_ps_nodop_B(sour,ant,t0,dt,N,ph0,icreal)
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

% Version 2.0 - January 20010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ph0','var')
    ph0=0;
end

if ~exist('icreal','var')
    icreal=1;
end

ph0=ph0*pi/180;

t=(0:N-1)*dt;
SF=1/86164.09053083288;

if isnumeric(sour)
    A=sour;
    fr=ant;
    s0=exp(1j*fr*2*pi*t+ph0);
    gdps=0;
    for i = 1:5
        gdps=gdps+A(i)*exp(1j*(i-3)*SF*2*pi*t).*s0;
    end
else
    sour=new_posfr(sour,t0);
    fr=sour.f0;
    s0=exp(1j*fr*2*pi*t+ph0);

    [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,ant);
    
    Omt=t*SF*2*pi;
    Ap=real(L0(3))+2*real(L0(4))*cos(Omt)+2*real(L0(5))*cos(2*Omt);
    Ac=2*real(L45(4))*cos(Omt)+2*real(L45(5))*cos(2*Omt);
    gdps=(Ap*Hp+Ac*Hc).*s0;
end

if icreal == 1
    gdps=real(gdps);
else
    gdps=gdps/sqrt(2);
end

gdps=gd(gdps);
gdps=edit_gd(gdps,'dx',dt);  