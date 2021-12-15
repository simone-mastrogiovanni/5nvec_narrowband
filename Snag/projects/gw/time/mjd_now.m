function mjd=mjd_now()
% now in mjd
%
%   mjd=mjd_now()

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t1 = datetime('now','TimeZone','Etc/GMT');
mjd=juliandate(t1)-2400000.5;