function tdt=tai2tdt(tai)
%TAI2TDT conversion from TAI to Terrestrial Dynamical Time
%
%  TAI and TDT are in mjd days

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tdt=tai+32.184/86400;
