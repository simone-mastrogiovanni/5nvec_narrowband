function sour=pulsar_7()
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 4.1487e-20            ## plus-polarization signal amplitude
% aCross          = 3.9927e-20            ## cross-polarization signal amplitude
% psi             = 0.512322887           ## polarization angle psi
% phi0            = 5.25                  ## phase at tRef 
% f0              = 1220.979581           ## GW frequency at tRef
% latitude        = -0.356930834          ## latitude (delta,declination) in radians
% longitude       = 3.899512716           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -1.12E-09             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0

% New (O1)
%     eta: -0.9624
%      h0: 2.5156e-24
%     h0L

disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_7';
sour.a=223.4256207843968;
sour.d=-20.450630366284585;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=1220.979581;
sour.df0=-1.12E-09 	;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[227.0071306286772 -3.690405093824686];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=-0.962397859570485;
sour.psi=29.353939173057785;
% sour.h=2.399123283879661e-24;
sour.h=2.5156e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;