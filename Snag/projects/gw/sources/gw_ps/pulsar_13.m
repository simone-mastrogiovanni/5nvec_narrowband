function sour=pulsar_13()
% PULSAR_13  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
%
% HI "similar" to J0205+6449
%
% h0=8.649785950510936e-025
% h+=4.794129917157555e-025
% hx=-2.849139907946041e-025
% iota=1.90645217306
% psi=0.41170074258401
% phi0=5.16105342591198
% alpha=0.54817301146
% delta=1.13147175151
% f0= 31.4248598      ## GW frequency at tRef
% fdot=-8.9730e-011
%
% refTime = 988243215  ## May01,11-00:00:00, pulsar 
%
%  refTime  mjd 55682  01-Nov-2003 00:00:00
%  alpha     31.4080
%  delta     64.828556

% New (O1)
% eta: 0
% h0: 1.1180e-22
% h0L: 2.2361e-22
% psi: 0
% alpha: 0.25
% delta: 0.25
% refTime: 930582085

disp(' ')
disp(' *** Could be not updated - for updated version use read_pulsar_Ligo_file')

sour.name='pulsar_13';
% sour.a=31.4080;
% sour.d=64.828556;
sour.a=14.3239;
sour.d=14.3239;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=55682;
sour.f0=31.4248598;
sour.df0=-8.9730e-011;
sour.ddf0=0;
% sour.fepoch=55682;
sour.fepoch=55014.6258;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0;
% sour.psi=0.41170074258401*180/pi;
sour.psi=0;
%sour.h=5.576852147729566e-025;
sour.h=1.1180e-22;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;
