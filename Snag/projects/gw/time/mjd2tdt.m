function tdt=mjd2tdt(mjd)
%MJD2TDT
%
%  TDT is in mjd days

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tdt=mjd+leap_seconds(mjd)/86400+32.184/86400;
