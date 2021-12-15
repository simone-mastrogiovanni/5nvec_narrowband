function sour=pulsar_2ss()

sour=pulsar_2;
f1=sour.f0;

sour.f0=f1+sour.dfrsim;
sour.df0=sour.df0*sour.f0/f1;
sour.ddf0=sour.ddf0*sour.f0/f1;
sour.h=sour.h*1e20;
