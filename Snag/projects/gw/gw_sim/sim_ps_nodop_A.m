function [gdps A H]=sim_ps_nodop_A(sour,ant,t0,dt,N,ph0,icreal)
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
    H=0;
else
    sour=new_posfr(sour,t0);
    fr=sour.f0;

    [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,ant);
    H=[Hp Hc];
end

s0=exp(1j*fr*2*pi*t+ph0); 
% gdps=0;
% for i = 1:5
%     gdps=gdps+A(i)*exp(1j*(i-3)*SF*2*pi*t).*s0;
% end

Omt=t*SF*2*pi;
Ap=real(L0(3))+real(L0(4))*cos(Omt)+imag(L0(4))*sin(Omt)+real(L0(5))*cos(2*Omt)+imag(L0(5))*sin(2*Omt);
Ac=real(L45(4))*cos(Omt)+imag(L45(4))*sin(Omt)+real(L45(5))*cos(2*Omt)+imag(L45(5))*sin(2*Omt);
gdps=real((Ap*Hp+Ac*Hc).*s0);

% figure
% for i = 1:5
%     x=A(i)*exp(-1j*(i-3)*SF*2*pi*t).*s0; plot(abs(x),'color',rotcol(i)),hold on
%     gdps=gdps+x;
% end
% plot(abs(gdps)),norm(A)


% if icreal == 1
%     gdps=real(gdps);
% else
%     gdps=gdps/sqrt(2);
% end

gdps=gd(gdps);
gdps=edit_gd(gdps,'dx',dt);  