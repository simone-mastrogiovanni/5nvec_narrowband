function tt=mjd2tt(mjd)
%MJD2TT
%
%  TT is in mjd days

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tt=mjd+(leap_seconds(mjd)+32.184)/86400;
