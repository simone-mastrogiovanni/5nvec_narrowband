function mjd2=adds2mjd(mjd1,nsec)
% adds seconds to a mjd
%

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

gps1=mjd2gps(mjd1);
mjd2=gps2mjd(gps1+nsec);