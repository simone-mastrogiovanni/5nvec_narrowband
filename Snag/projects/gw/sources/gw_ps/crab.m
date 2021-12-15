function sour=crab()

clear sour 

sour.name='crab';
sour.a=83.633218; 
sour.d=22.01446361111;
sour.v_a=0.0; % marcs/y
sour.v_d=0.0;   % marcs/y
sour.pepoch=5.463200000022558e+04;
sour.f0=59.473551262000001;
sour.df0=-7.433700409800000e-10;
sour.ddf0=2.359316462680000e-20;
sour.fepoch=54936;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eta=-0.7667; 
sour.iota=62.165;
sour.siota=0.8531;
sour.psi=35.155;
sour.spsi=0.0908;
sour.h=1.400000000000000e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;
sour.ephfile='/storage/targeted/band_recos/crab_ephemeris_file_O1.txt';
sour.ephstarttime=57249;
sour.ephendtime=57403;
