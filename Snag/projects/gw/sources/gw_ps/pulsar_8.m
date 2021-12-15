function sour=pulsar_8()
% PULSAR_8  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 7.9815e-24            ## plus-polarization signal amplitude
% aCross          = 1.1733e-24           ## cross-polarization signal amplitude
% psi             = 0.170470927           ## polarization angle psi
% phi0            = 5.89              ## phase at tRef 
% f0              = 194.3083185   	## GW frequency at tRef
% latitude        = -0.583263151           ## latitude (delta,declination) in radians
% longitude       = 6.132905166           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -8.65E-09             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    351.3895821657795
%  delta    -33.418516897801645

% New (O1)
%     eta: -0.1470
%      h0: 5.5902e-25
%     h0L: 1.1001e-24

disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_8';
sour.a=351.3895821657795;
sour.d=-33.418516897801645;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=194.3083185;
sour.df0=-8.65E-09;
sour.ddf0=0;
sour.fepoch=52944;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=0;
sour.eta=-0.1470;
sour.psi=9.7673;
% sour.h=8.0673e-024;
sour.h=5.5902e-25;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;