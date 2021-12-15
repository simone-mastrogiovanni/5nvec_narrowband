function sour=pulsar_5()
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 2.94475e-24            ## plus-polarization signal amplitude
% aCross          = 2.245375e-24            ## cross-polarization signal amplitude
% psi             = -0.363953188          ## polarization angle psi
% phi0            = 2.23              ## phase at tRef 
% f0              = 52.80832436   	## GW frequency at tRef
% latitude        = -1.463269033          ## latitude (delta,declination) in radians
% longitude       = 5.281831296           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -4.03E-18             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    302.6266
%  delta    -83.8391

%  New (O1)
%     eta: -0.7625
%      h0: 1.1180e-24
%     h0L: 1.4643e-24

disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_5';
sour.a=302.6266413609139;
sour.d=-83.839139883089175;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=52.80832436;
sour.df0=-4.03E-18;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[276.8964 -61.1909];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=-0.762501061210629;
sour.psi=-20.852981612731398;
% sour.h=3.703142105445726e-024;
sour.h=1.1180e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;