function mjd=tai2mjd(tai)
%TAI2MJD
%
%  TAI is in mjd days

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mjd=tai-leap_seconds(tai)/86400;
