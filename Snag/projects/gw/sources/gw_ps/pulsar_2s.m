function sour=pulsar_2s()
% PULSAR_2  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 3.74175e-24            ## plus-polarization signal amplitude
% aCross          =-3.7315e-24            ## cross-polarization signal amplitude
% psi             = -0.221788475            ## polarization angle psi
% phi0            = 4.03              ## phase at tRef 
% f0              = 575.163573    	## GW frequency at tRef
% latitude        = 0.060108958          ## latitude (delta,declination) in radians
% longitude       = 3.75692884           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -1.37E-13             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    215.2562
%  delta    3.4440


sour.a=215.2561664629801;
sour.d=3.443989604329126;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=575.163573+1;
sour.df0=-1.37E-13;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=0;
sour.eta=0.997;
sour.psi=77.292;
sour.h=5.2844e-024;
sour.snr=1;
sour.coord=0;
sour.chphase=0;