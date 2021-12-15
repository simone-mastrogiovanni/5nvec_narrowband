function s=gps2utc(gps)

mjd=gps2mjd(gps);
s=mjd2s(mjd);