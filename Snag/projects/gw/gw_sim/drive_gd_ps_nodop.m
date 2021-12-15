% drive_gd_ps_nodop

ant=virgo;
sour=vela;
sour.eps=0;
t0=v2mjd([2007 9 1 0 0 0]);
sour=new_posfr(sour,t0);
sour.df0=0;
sour.ddf0=0;
dt=1;
aa=86164.0905;
N=round(aa*20);

[gdps ft]=sim_ps_nodop(sour,ant,t0,dt,N);