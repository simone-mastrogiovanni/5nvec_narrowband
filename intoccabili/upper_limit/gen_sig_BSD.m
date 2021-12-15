function gg_sig=gen_sig_BSD(gg,H0,eta,psi,simsour,ant,ph_dop,ph_sd)
% THIS PROGRAM GENERATE A SIGNAL WITH THE DOPPLER EFFECT CORRECTED WORK
% FOR COHERENT SEARCHES
% Input:
% gg: gd where to inject the signal
% H0: amplitude to inject
% eta
% psi in rad
% simsour: Source structure
% ant: Antenna 
% ph_dop: Doppler phase correction
% ph_sd: Spin-down phase correction

% Output:
% gg_sig: gd with the injected signal.
%
%
% By: Simone Mastrogiovanni (2016): simone.mastrogiovanni@roma1.infn.it


Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi))
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi))
dtout=dx_gd(gg);
f0=simsour.f0;
dt=dx_gd(gg);
f0=simsour.f0-floor(simsour.f0*dt)/dt;
tt=x_gd(gg);
y=y_gd(gg);
izeros=find(y==0);
NS=length(tt);
cont=cont_gd(gg);
t0=cont.t0;
phase_sig=2*pi*f0*(0:NS-1)*dt;

nsid=10000; % number of points at which the sidereal response will be computed
SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency
stsub=gmst(t0)+dtout*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sida,sidb]=check_ps_lf(simsour,ant,nsid); % computation of the sidereal response
ph=mod(ph_dop+ph_sd.'+phase_sig.',2*pi); 

sid1=sida(isub);
sid2=sidb(isub);


rHp=real(Hp);
iHp=imag(Hp);
rHc=real(Hc);
iHc=imag(Hc);

%%%%%%%% COMPUTE SIMULATED WAVE %%%%%%%%%%%%
K1=rHp*sid1+rHc*sid2;
K2=iHp*sid1+iHc*sid2;
F1=cos(ph);
F2=sin(ph);
simr=K1.*(F1.')-K2.*(F2.');
simi=K1.*(F2.')+K2.*(F1.');

sim=simr+1j*simi;
sim=H0*sim;

sim=y+sim.';
sim(izeros)=0;
%figure;semilogy(abs(fft(sim)));
%figure;plot(real(sim));
%figure;semilogy(abs(fft(sim)));
%e0=exp(1j*ph);
%sim=real((Hp*sid1(i1)+Hc*sid2(i1)).*e0);
%sim=real(sim);
gg_sig=gg;
gg_sig=edit_gd(gg_sig,'y',sim);
end
