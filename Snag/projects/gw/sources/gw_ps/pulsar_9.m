function sour=pulsar_9()
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 5.6235e-25            ## plus-polarization signal amplitude
% aCross          = -5.034e-25            ## cross-polarization signal amplitude
% psi             = -0.008560279          ## polarization angle psi
% phi0            = 1.01                  ## phase at tRef 
% f0              = 763.8473165   	      ## GW frequency at tRef
% latitude        = 1.321032538           ## latitude (delta,declination) in radians
% longitude       = 3.471208243           ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -1.45E-17             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0

%New (O1)
%eta: 0.8952
%h0: 1.3975e-24
%h0L: 1.5054e-24

disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_9';
sour.a=198.8855821349219;
sour.d=75.689589026855558;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=52944;
sour.f0=763.8473165;
sour.df0=-1.45E-17 	;
sour.ddf0=0;
sour.fepoch=52944;
sour.ecl=[126.8517611336020 67.048857748907565];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0.895172045880381;
sour.psi=-0.490467858154469;
%sour.h=7.547510069574113e-25;
sour.h=1.3975e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;
