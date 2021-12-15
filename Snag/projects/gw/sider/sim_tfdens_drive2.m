% sim_tfdens_drive2

tau=30;
step=5;

clear simstr

% simstr.holes=0;

simstr.ant=virgo;

simstr.sid.phase=[0 0 0.5 1 1 1 1 1 0.5 0 0 0];
simstr.sid.amp=1;

% simstr.sol.phase=10;
% simstr.sol.amp=1;

simstr.noise.const=10;

out=sim_tfdens(g2in,simstr);

% outstr=sid_band_analysis(out,0,simstr.ant,'prova');

[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'sid',simstr.ant,0,0,tau,step);
[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'day',simstr.ant,0,0,tau,step);

[frtim_f frtim]=gd2_freq_ns(out,[0 0.01 2.3],0,tau,step);

% [phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'day',0,0,0,30,5,'prova');