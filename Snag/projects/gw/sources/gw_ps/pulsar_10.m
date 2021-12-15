function sour=pulsar_10()
% PULSAR 10
% refTime = 930582085          ## time at which params are computed 
% aPlus = 2.343323e-023        ## plus-polarization signal amplitude 
% aCross = -2.343145e-023      ## cross-polarization signal amplitude 
% psi = 0.61465097870534       ## polarization angle psi 
% phi0 = 0.11626181938654      ## phase at tRef 
% f0 = 26.3589129              ## GW frequency at tRef 
% latitude = 0.74835013347064  ## latitude (delta,declination) in rad 
% longitude = 3.86687548714555 ## longit (alpha, right asc.) in rad 
% f1dot = -8.50E-11            ## spindown parameters d/dt f0 
% f2dot = 0.0 
% f3dot = 0.0
%
%  refTime  mjd 55014.62581018519  02-Jul-2009 15:01:10.00
%  alpha    221.5556453160342
%  delta    42.877304245919518

% New (O1)
% eta: 0.9999
% h0: 5.5902e-24
% h0L: 4.0017e-24


disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_10';
sour.a=221.5556453160342;
sour.d=42.877304245919518;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=55014.62581018519;
sour.f0=26.3589129;
sour.df0=-8.50E-11;
sour.ddf0=0;
sour.fepoch=55014.62581018519;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
%sour.eta=0;
sour.eta=0.9999;
sour.psi=0;
%sour.h=10^-23;
sour.h=5.5902e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;
