% sim_tfdens_workday

load VSR2_aveDF_01
load VSR2_SM

[g2in up low cut]=gd2_rough_clean(VSR2_aveDF_01,0.02,0.01,VSR2_SM,512/86400);

tau=30;
step=5;

clear simstr

gencapt='Working day';

% simstr.holes=0;

simstr.ant=virgo;

% simstr.sid.phase=10;
% simstr.sid.phase=[0 50 100 200;10 20 5 10];
% simstr.sid.amp=1; 

simstr.sol.phase=[0 0 0.1 0.1 0.3 0.5 0.6 0.9 1 1 0.9 0.9 1 1 0.9 0.8 0.6 0.5 0.4 0.3 0.2 0.1 0.1 0];
simstr.sol.amp=1;

% simstr.othfr.freq=[0.002 0.9];
% simstr.othfr.freq=1.5
% simstr.othfr.amp=[0.01 1];

simstr.noise.const=10;

out=sim_tfdens(g2in,simstr); 

% outstr=sid_band_analysis(out,0,simstr.ant,'prova');

%% sid_band_analysis
outstr=sid_band_analysis(out,0,simstr.ant,gencapt);

%% gd2_period_ns sid
[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'sid',simstr.ant,0,0,tau,step,gencapt);

%% gd2_period_ns day
[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'day',0,0,0,tau,step,gencapt);
% [phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,1/1.5,0,0,0,tau,step,gencapt);

%% gd2_freq_ns
[frtim_f frtim]=gd2_freq_ns(out,[0 0.01 2.3],0,tau,step);
