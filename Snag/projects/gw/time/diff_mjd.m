function s=diff_mjd(mjd1,mjd2)
% DIFF_MJD  difference in s for two mjd dates
%
%    s=diff_mjd(mgd1,mjd2)
%
%    mjd1,mjd2   dates
%
%    s           seconds in mjd2-mjd1

s=(mjd2*86400-mjd1*86400)+(leap_seconds(mjd2)-leap_seconds(mjd1));