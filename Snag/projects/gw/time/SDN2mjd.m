function mjd=SDN2mjd(sdn)
% converts serial date number (as that produced by "now") to mjd
%
%   mjd=SDN2mjd(sdn)

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t0=mjd2s(0);
t0=datenum(t0);

mjd=sdn-t0;