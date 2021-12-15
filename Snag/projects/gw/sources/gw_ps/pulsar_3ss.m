function sour=pulsar_3ss()

sour=pulsar_3;
f1=sour.f0;

sour.f0=f1+sour.dfrsim;
sour.df0=sour.df0*sour.f0/f1;
sour.ddf0=sour.ddf0*sour.f0/f1;
sour.h=sour.h*1e20;
