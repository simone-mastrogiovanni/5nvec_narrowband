function sour=pulsar_x()
% PULSAR_X  dummy pulsar
%

sour.name='pulsar_x';
sour.a=0;
sour.d=0;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=1;
sour.df0=0;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[0 0];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0;
sour.psi=0;
sour.h=1;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;