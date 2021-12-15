function sour=pulsar_x1()
% PULSAR_X1  source parameters (blind injection)
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% 
% Inserted a pulsar signal during the last part of the run, st artin g at:
% • H1- 969837280
% • L1 - 969837694
% • VI - 969869000
% • refTime = 751680013 pulsar reference time in SSB frame
% • aPlus = 3.02930e-24 plus-polarization signal amplitude
% • aCross = 3.01724e-24 cross-polarization signal amplitude
% • psi = 0.15823742 polarization angle psi
% • phi0 = 4.29 phase at tRef
% • f0 = 643.3517213 GW frequency at tRef
% • latitude = 0.465456321 latitude (delta/declination) in radians
% • longitude = 2.453682475 longitude (alpha, right ascension) in radians
% • fldot = -8.84E-11 spindown parameters d/dt fa
% • f2dot = 0.0
% • f3dot = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    140.5856457855307
%  delta    26.668682740986469
%
% converted by vpar=pss_lsc2virgo_par(lpar)

sour.a=140.5856457855307;
sour.d=26.668682740986469;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=643.3517213;
sour.df0=-8.84e-11;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=0;
sour.eta=-0.996018882250025;
sour.psi= 9.066336327039002;
sour.h=4.275557941087923e-024;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;