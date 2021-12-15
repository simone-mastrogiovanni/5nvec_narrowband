function sour=velas(t)
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
% 2009:
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

if ~exist('t','var')
    t0=v2mjd([2009 7 7 0 0 0]);
    t=2009;
else
    t0=v2mjd([2007 5 28 0 0 0]);
    t=2007;
end

sour=vela(t);
sour=new_posfr(sour,t0);
fprintf('Attention to the epoch !  now %s \n',mjd2s(t0))
f1=sour.f0

sour.f0=f1+sour.dfrsim;
sour.df0=sour.df0*sour.f0/f1;
sour.ddf0=sour.ddf0*sour.f0/f1;
sour.h=sour.h*100*1e20;
