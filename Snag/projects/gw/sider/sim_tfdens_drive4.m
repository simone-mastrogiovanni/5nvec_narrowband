% sim_tfdens_drive4

cd('C:\Users\Sergio Frasca\Documents\Matlab\Raw_LigoH_HF')
load('LH_S6_SM.mat')
load('LH_S6_aveHF_01.mat')
LH_S6_sel_lp1
i=1
strfil=sprintf('LH_S6_aveHF_%02d',i);
fprintf('File %s band %d - %d Hz \n',strfil,(i-1)*400,i*400)
eval(['load ' strfil])
eval(['[g2out up low cut]=gd2_rough_clean(' strfil ',0.10,0.05,{LH_S6_SM,LHintyes},512/86400);'])
eval(['clear ' strfil])
g2in=g2out

tau=30;
step=5;

clear simstr

% simstr.holes=0;

simstr.ant=ligoh;

simstr.ann.phase=0;
simstr.ann.amp=1;

simstr.noise.const=10;

out=sim_tfdens(g2in,simstr); 

outstr=sid_band_analysis(out,0,simstr.ant,'prova');

[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'sid',simstr.ant,0,0,tau,step);
[phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'day',simstr.ant,0,0,tau,step);

[frtim_f frtim]=gd2_freq_ns(out,[0 0.01 2.3],0,tau,step);

% [phtim_f phtim phtim1 phtim0 win]=gd2_period_ns(out,'day',0,0,0,30,5,'prova');