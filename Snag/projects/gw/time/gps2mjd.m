function mjd=gps2mjd(tgps)
%GPS2MJD   conversion from gps time to mjd
%
%     t=gps2mjd(tgps)
%
%     tgps   gps time (in seconds)
%     mjd    modified julian date (days)
%
%  GPS time is 0 at 6-Jan-1980 0:00:00 and it is linked to TAI.
%  It is offset from UTC for the insertion of the leap seconds.
%

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

t0=44244;
mjd=tgps/86400+t0;
mjd=mjd-(leap_seconds(mjd)-19)/86400;