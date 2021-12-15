function tsid=snag_tsid(time,long)
%SNAG_TSID  converts the time (in serial days UT) to tsid (in local sidereal days)
%
%      tsid=snag_tsid(time,long)
%
%  time is in day, long in degrees

tsid=time./0.9972695667+(100.18+long)/360;
tsid=tsid-floor(tsid);