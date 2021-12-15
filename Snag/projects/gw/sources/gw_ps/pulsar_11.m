function sour=pulsar_11()
% PULSAR 11
% refTime = 930582085
% aPlus = 9.958896e-023 ## plus-polarization signal amplitude 
% aCross = -5.918548e-023 ## cross-polarization signal amplitude 
% psi = 0.41170074258401 ## polarization angle psi 
% phi0 = 5.16105342591198 ## phase at tRef 
% f0 = 31.4248598 ## GW frequency at tRef 
% latitude = -1.01703990217401 ## latitude 
% longitude = 4.97588715777288 ## longitude 
% f1dot = -5.07E-13 ## spindown parameters d/dt f0 
% f2dot = 0.0 
% f3dot = 0.0
%
%  refTime  mjd 55014.62581018519  02-Jul-2009 15:01:10.00
%  alpha    285.0973334737328
%  delta    -58.272093990968898
% 
%New (O1)
%eta: 0.5943
%h0: 3.6336e-24
%h0L: 5.6358e-24


disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_11';
sour.a=285.0973334737328;
sour.d=-58.272093990968898;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=55014.62581018519;
sour.f0=31.4248598;
sour.df0=-5.07E-13;
sour.ddf0=0;
sour.fepoch=55014.62581018519;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
%sour.eta=0;
sour.eta=0.5943;
sour.psi=0;
%sour.h=10^-23;
sour.h=3.6336e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;
