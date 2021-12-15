function sour=pulsar_4s()
% PULSAR_4  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 2.45645e-23            ## plus-polarization signal amplitude
% aCross          = 1.26515e-23            ## cross-polarization signal amplitude
% psi             = -0.647939117          ## polarization angle psi
% phi0            = 4.83              ## phase at tRef 
% f0              = 1403.163331+1   	## GW frequency at tRef
% latitude        = -0.217583646          ## latitude (delta,declination) in radians
% longitude       = 4.886706854           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -2.54E-08             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    279.9876784976888
%  delta    -12.466624606868557

sour.a=279.9876784976888;
sour.d=-12.466624606868557;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=1403.163331+1;
sour.df0=-2.54E-08;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=0;
sour.eta=-0.515;
sour.psi=-37.124;
sour.h=2.7631e-023;
sour.snr=1;
sour.coord=0;
sour.chphase=0;