function sour=pulsar_1s()
% PULSAR_1  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013           ## pulsar reference time in SSB frame
% 
% aPlus           = 6.4405e-25          ## plus-polarization signal amplitude
% aCross          = 4.91675e-25        ## cross-polarization signal amplitude
% psi             = 0.35603553         ## polarization angle psi
% phi0            = 1.28                ## phase at tRef 
% f0              = 849.0832962     	## GW frequency at tRef
% latitude        = -0.514042406        ## latitude (delta,declination) in radians
% longitude       = 0.652645832         ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -3.00E-10           ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    0
%  delta    0


sour.a=37.393851690404169;
sour.d=-29.452460354550343;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=849.0832962+1;
sour.df0=-3.00E-10;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=-0.763411225836503;
sour.psi=20.399333225703408;
sour.h=8.102744646877377e-025;
sour.snr=1;
sour.coord=0;
sour.chphase=0;