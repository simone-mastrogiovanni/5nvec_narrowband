function tgps=mjd2gps(mjd)
%MJD2GPS  conversion from mjd days to gps seconds
%

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

t0=44244;
tgps=(mjd-t0)*86400+(leap_seconds(mjd)-19);