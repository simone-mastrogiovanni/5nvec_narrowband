% start_pss_sim_pm_lrA command file

sim_level=1;

load 'D:\Data\Virgo\Doppler\Virgo2003_dop_tab.mat'
doptab=Virgo2003_dop_tab';
clear Virgo2003_dop_tab

ant.lat=43.67;
ant.long=10.5;
ant.azim=0;
ant.type=2;

pmstr.dt=0.01;
pmstr.res=2;
pmstr.lfft=2^23;
dfr=1/(pmstr.dt*pmstr.lfft);
pmstr.frin=dfr*round(pmstr.lfft/3);
pmstr.nfr=1000;
pmstr.t0=52671; % from v2mjd([2003 2 1 0 0 0])
pmstr.np=1000;
pmstr.thresh=0.1;
pmstr.win=3;

sour(1).a=120;
sour(1).d=30;
sour(1).eps=1;
sour(1).psi=0;
sour(1).f0=pmstr.frin+dfr*300;
sour(1).df0=0;
sour(1).ddf0=0;
sour(1).snr=20;
sour(1).t00=v2mjd([2000,1,1,0,0,0]);

sour(2).a=-28.93;
sour(2).d=266.4;
sour(2).eps=0;
sour(2).psi=0;
sour(2).f0=pmstr.frin+dfr*500;
sour(2).df0=0;
sour(2).ddf0=0;
sour(2).snr=10;
sour(2).t00=v2mjd([2000,1,1,0,0,0]);

pm=pss_sim_pm_lr(ant,sour,pmstr,doptab,sim_level);

pss_w_pm_0(pm,'pm.dat')