function out_cell=gen_sig_dopp(simsour,ant,tt,g_p,t0,Ninj,dfinj,dtout)
% THIS PROGRAM GENERATE A SIGNAL WITH THE DOPPLER EFFECT CORRECTED WORK
% FOR COHERENT SEARCHES
% Input:
% simsour: source to be simulated
% ant: antenna used for the simulation
% tt: Time not corrected for Doppler effect
% g_p: Doppler corrections in time
% t0: Intial time of the data set in MJD
% Ninj: Number of injection you want to do, put 1 to inj. 1 signal
% dfinj: frequency distance of the injection (AT LEAST 8*Sideral Freq+ Frequency bin), put 0 to inject 1 signal
% dtout: Down-sampling time
% 
% Output:
% out_cell: Cell array containing in {1} the simulated time series, at {2} the injected wave.
%
%
% By: Simone Mastrogiovanni (2016): simone.mastrogiovanni@roma1.infn.it

tt2=0.5*tt.^2;
tt3=(1/6)*tt.^3;
if isfield(simsour,'ephfile')
   simsour=rmfield(simsour,'ephfile');
   simsour=rmfield(simsour,'ephstarttime');
   simsour=rmfield(simsour,'ephendtime');
end


[tephem f0ephem df0ephem ephyes]=read_ephem_file(simsour);
simsour_new=use_ephem_file(ephyes,t0,simsour,tephem,f0ephem,df0ephem); % Update the source parameters to the start time of data set
simsour=simsour_new;

eta=simsour.eta;
psi=simsour.psi*pi/180;
Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi))
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi))
%f0=simsourupd.f0-floor(simsourupd.f0);
f0=simsour.f0;
fr0int=floor(simsour.f0);
df0=simsour.df0;
ddf0=simsour.ddf0;
f0=f0-fr0int;
ph1=(f0*tt+df0*(tt2)+ddf0*(tt3))*2*pi; % Spin-down phase evolution
f0a=(f0+df0*tt+ddf0*tt2); 
ph2=f0a.*g_p*2*pi;  % Romer phase evolution
ph=mod(ph2+ph1,2*pi); 

%%%% BLOCK TO INJECT N SIGNAL AT A DISTANCE OF dfinj THE SAME TIME%%%%%%%%
suppA=1-exp(2*pi*1j*dfinj*(Ninj)*(tt+g_p));
suppB=1-exp(2*pi*1j*dfinj*(tt+g_p));
if dfinj==0
   suppA=ones(length(tt),1); 
   suppB=ones(length(tt),1); 
end
freq_fact=suppA./suppB;
torem=find(g_p==0);
freq_fact(torem)=1; % Remove NaN components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NS=length(tt);

nsid=10000; % number of points at which the sidereal response will be computed
SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency
stsub=gmst(t0)+dtout*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sida,sidb]=check_ps_lf(simsour,ant,nsid); % computation of the sidereal response

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
sim=simsour.h*sim;
sim=sim.*(freq_fact.');
%e0=exp(1j*ph);
%sim=real((Hp*sid1(i1)+Hc*sid2(i1)).*e0);
%sim=real(sim);

cont.sour=simsour;
cont.t0=t0;
cont.appf0=simsour.f0;
cont.df0=simsour.df0;
gtime=tt+g_p;
ii=find(gtime==0);
sim(ii)=0;
gg_sc=gd(sim);
gg_sc=edit_gd(gg_sc,'cont',cont,'dx',dtout,'x',gtime);
out_cell{1}=gg_sc;
%%%%%%%%%%%%%%%%%%%%

wave.psi=psi;
wave.eta=eta;
wave.h=simsour.h;
wave.hp=Hp;
wave.hc=Hc; 
wave.sdindex=simsour.sdindex;
wave.f0=simsour.f0;
out_cell{2}=wave;
%sim=fft(sim);
end
