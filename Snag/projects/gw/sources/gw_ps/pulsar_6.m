function sour=pulsar_6()
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 3.54275e-25           ## plus-polarization signal amplitude
% aCross          = -1.064125e-25         ## cross-polarization signal amplitude
% psi             = 0.470984879           ## polarization angle psi
% phi0            = 0.97                  ## phase at tRef 
% f0              = 148.7190257   	      ## GW frequency at tRef
% latitude        = -1.14184021           ## latitude (delta,declination) in radians
% longitude       = 6.261385269           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -6.73E-09             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0

% New (O1)
%     eta: 0.3004
%      h0: 4.7516e-25
%     h0L: 8.8914e-25


disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_6';
sour.a=358.7509498190856;
sour.d=-65.422624911331610;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=148.7190257;
sour.df0=-6.73E-09;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[318.3328712865202 -56.176081562354362];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0.300366946573577;
sour.psi=26.985445781179759;
% sour.h=3.699113350255170e-25;
sour.h=4.7516e-25;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;