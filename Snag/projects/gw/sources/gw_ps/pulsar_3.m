function sour=pulsar_3()
% PULSAR_3  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 8.1915e-24           ## plus-polarization signal amplitude
% aCross          = -1.313e-24           ## cross-polarization signal amplitude
% psi             = 0.444280306           ## polarization angle psi
% phi0            = 5.53                 ## phase at tRef 
% f0              =  108.8571594     	## GW frequency at tRef
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

% New (O1)
% eta: 0.1603
% h0: 4.1926e-25
% h0L: 8.2260e-25


disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_3';
sour.a=178.3725740253688;
sour.d=-33.436602425196504;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=108.8571594;
sour.df0=-1.46E-17;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[193.3162 -30.9956];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0.160;
sour.psi=25.439;
% sour.h=8.2961e-024;
sour.h=4.1926e-25;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;