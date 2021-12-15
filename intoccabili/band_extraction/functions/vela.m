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
% 2009-2010 NO LABEL (Pitkin)
%
% PSRJ           J0835-4510
% RAJ            08:35:20.7543822 1 2.5047e-05              
% DECJ           -45:10:32.95068 1 0.00068262              
% F0             11.1905730233076     1  8.5742e-11   
% F1             -1.55838759952784e-11 1 3.9307e-18 
% F2             4.90687976149349e-22 1  8.7082e-26
% F3             0                           
% PEPOCH         54620                       
% POSEPOCH       54620                       
% DMEPOCH        54620                       
% DM             67.95657198718651016                               
% CLK            TT(TAI)
% EPHEM          DE405
%
%  .dfrsim = -0.2;

% O1 - Sarah Buchner
%PSRJ           0833-45
%RAJ             08:35:20.5630594           
%DECJ           -45:10:34.56689             
%F0             11.186962836376691534     1  0.00000000000611899903   
%F1             -1.5593594916955414598e-11 1  1.9207927605197489201e-18
%F2             4.2448705487377537477e-22 1  2.1186602031731684737e-24
%PEPOCH         57341                       
%POSEPOCH       57341                       
%DMEPOCH        57341                       
%DM             68.088676186716312971        0.00440263718827431719   
%PMRA           -49.68                       0.06000000000000000000   
%PMDEC          29.9                         0.10000000000000000000   
%PX             3.5                         
%START          57283.050041646049067       
%FINISH         57399.216579724743497       
%TZRMJD         57341.125995487637827       
%TZRFRQ         1710                     
%TZRSITE        hart   
%TRES           31.654       
%EPHVER         5                           
%CLK            TT(TAI)
%MODE 1
%UNITS          TCB
%TIMEEPH        IF99
%DILATEFREQ     Y
%PLANET_SHAPIRO Y
%T2CMETHOD      IAU2000B
%NE_SW          4.000
%CORRECT_TROPOSPHERE  Y
%EPHEM          DE405
%NITS           1
%NTOA           2901
%CHI2R          419.3084 2897


if ~exist('t','var')
    t=2015;
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

sour.ecl=[153.3702 -60.3618];

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
        elseif strcmp(label,'VSR4')
            sour.a=hour2deg('8:35:20.7543822'); 
            sour.d=-(45+10/60+32.95068/3600);
            sour.v_a=-49.68; % marcs/y
            sour.v_d=29.9;   % marcs/y
            sour.pepoch=54620;
            sour.f0=11.1905730233076*2;
            sour.df0=2*(-1.55838759952784e-11);
            sour.ddf0=2*4.90687976149349e-22;
            sour.fepoch=54620;
        else
            sour.a=hour2deg('8:35:20.5630594'); 
            sour.d=-(45+10/60+34.56689/3600);
            sour.v_a=-49.68; % marcs/y
            sour.v_d=29.9;   % marcs/y
            sour.pepoch=57341;
            sour.f0=11.186962836376691534*2;
            sour.df0=2*(-1.5593594916955414598e-11);
            sour.ddf0=2*4.2448705487377537477e-22;
            sour.fepoch=57341;
        end
end
            
sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eta=-0.7425;
sour.psi=130.63;
sour.h=3.29e-18;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;
