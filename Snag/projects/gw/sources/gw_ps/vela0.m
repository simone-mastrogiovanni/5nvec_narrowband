function sour=vela(t,label)
% VELA  source parameters
% 
%   t    mjd or year
%
% 2007:
%
% PSRJ           J0835-4510
% RAJ            08:35:20.61149001
% DECJ           -45:10:34.8751001
% F0             11.191197456560310528     1  0.00000018256289700481
% F1             -1.5625272699742110098e-11 1  2.2725744371831674596e-14
% F2             1.2624323005072600791e-21 1  1.4135226613540255917e-21
% PEPOCH         54157
% POSEPOCH       54157
% DMEPOCH        54157
% DM             68.150705052039449373        0.02107806166545630674
% PMRA           -49.68
% PMDEC          29.9
% PX             3.5
% TRACK          0
% TZRMJD         54325.245785337266799
% TZRFRQ         1450
% TZRSITE        4
% EPHVER         5
% CLK            TT(TAI)
% EPHEM          DE405
% NITS           1
% NTOA           138
%
% 2009 LABEL "OLD":
%
% PSRJ           J0835-4510
% RAJ             08:35:20.6742931            0.00582093431713258702
% DECJ           -45:10:36.52117              0.04877648687498226259
% F0             11.1905728445107        1          1.9079e-08
% F1             -1.55774281157927e-11   1  	1.05e-15
% F2             4.03370032122227e-22    1  	2.8777e-23
% PEPOCH         54620
% POSEPOCH       54620
% DMEPOCH        54620
% DM             67.95657198718651016
% START          54990.2304808061
% FINISH         55085.2632566052
% TRACK	       0
% TZRMJD         55045.1343394547
% TZRFRQ         1440
% TZRSITE        4
% TRES           51.2836543674149
% CLK            TT(TAI)
% EPHEM          DE405
% NITS           1
% NTOA           3158
%
%
% 2009 NO LABEL (Pitkin) :
%
% RAJ             08:35:20.6742931            0.00582093431713258702
% DECJ           -45:10:36.52117              0.04877648687498226259
% PARAMETER Pre-fit Post-fit Uncertainty Difference Fit
% F0             11.1905727516166 11.1905725907206 9.9365e-12 -1.609e-07 Y
% F1             -1.55715544937594e-11 -1.55638901986605e-11 4.3826e-19 7.6643e-15 Y
% F2             2.19118581215678e-22 4.51689933023785e-23 9.5126e-27 -1.7395e-22 Y
% PEPOCH         54620
% POSEPOCH       54620
% DMEPOCH        54620
% DM             67.95657198718651016
% START          54983.3386179652
% FINISH         55286.0587173187
% TZRMJD         55134.8768299019
% TZRFRQ         1501.279
% TZRSITE        xdm
% TRES           232.398479765617
% EPHVER 0 5 0 5 N 
% WAVEEPOCH (MJD) 54620 54620 0 0 N
%
%  .dfrsim = -0.2;

if ~exist('t','var')
    t=2009;
end

if ~exist('label','var')
    label='no';
end

if t > 3000
    if t < 54620
        t=2007;
    else
        t=2009;
    end
end

clear sour

switch t
    case 2007
        sour.a=hour2deg('08:35:20.61149001'); %128.8358812083750;
        sour.d=-45.176352777777772;
        sour.v_a=-49.68; % marcs/y
        sour.v_d=29.9;   % marcs/y
        sour.pepoch=54157;
        sour.f0=22.382394913120621;
        sour.df0=2*(-1.5625272699742110098e-11);
        sour.ddf0=2*1.2624323005072600791e-21;
        sour.fepoch=54157;
    otherwise
        if strcmp(label,'old')
            sour.a=hour2deg('08:35:20.6742931'); 
            sour.d=-(45+10/60+36.52117/3600);
            sour.v_a=-49.68; % marcs/y
            sour.v_d=29.9;   % marcs/y
            sour.pepoch=54620;
            sour.f0=22.381145689021398;
            sour.df0=2*(-1.55774281157927e-11);
            sour.ddf0=2*4.03370032122227e-22;
            sour.fepoch=54620;
        else
            sour.a=hour2deg('08:35:20.6742931'); 
            sour.d=-(45+10/60+36.52117/3600);
            sour.v_a=-49.68; % marcs/y
            sour.v_d=29.9;   % marcs/y
            sour.pepoch=54620;
            sour.f0=11.1905725907206*2;
            sour.df0=2*(-1.55638901986605e-11);
            sour.ddf0=2*4.51689933023785e-23;
            sour.fepoch=54620;
        end
end
            
sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eta=-0.7425;
sour.psi=130.63;
sour.h=3.29e-24;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;