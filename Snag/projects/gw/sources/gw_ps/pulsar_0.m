function sour=pulsar_0()
% PULSAR_0  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013           ## pulsar reference time in SSB frame
% 
% aPlus           = 2.0125e-25          ## plus-polarization signal amplitude
% aCross          = 1.960625e-25        ## cross-polarization signal amplitude
% psi             = 0.770087086         ## polarization angle psi
% phi0            = 2.66                ## phase at tRef 
% f0              = 265.5771052     	## GW frequency at tRef
% latitude        = -0.981180225        ## latitude (delta,declination) in radians
% longitude       = 1.248816734         ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -4.15E-12           ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    0
%  delta    0

% New (O1)
% 
%     eta: -0.9742
%      h0: 5.5902e-25
%     h0L: 4.9074e-25

disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')
sour.name='pulsar_0';
sour.a=71.551928243511583;
sour.d=-56.217485834196502;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=265.5771052;
sour.df0=-4.15E-12;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=-0.974223602484472;
sour.psi=44.122739885328066;
% sour.h=2.809663083116016e-025;
sour.h=5.5902e-25;
sour.snr=1;
sour.coord=0;
sour.chphase=0;