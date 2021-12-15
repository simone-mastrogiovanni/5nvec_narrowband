function sour=pulsar_3a()
% PULSAR_3A  PULSAR_3 - 0.01 Hz
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 8.1915e-24           ## plus-polarization signal amplitude
% aCross          = -1.313e-24           ## cross-polarization signal amplitude
% psi             = 0.444280306           ## polarization angle psi
% phi0            = 5.53                 ## phase at tRef 
% f0              =  108.8471594     	## GW frequency at tRef
% latitude        =  -0.583578803         ## latitude (delta,declination) in radians
% longitude       =  3.113188712          ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -1.46E-17             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    178.3726
%  delta    -33.4366


sour.a=178.3726;
sour.d=-33.4366;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=108.8571594-0.01;
sour.df0=-1.46E-17;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0;
sour.psi=0;
sour.h=10^-23;
sour.snr=1;
sour.coord=0;
sour.chphase=0;