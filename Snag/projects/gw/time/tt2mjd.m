function mjd=tt2mjd(tai)
%TT2MJD
%
%  TT is in mjd days

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mjd=tai-(leap_seconds(tai)+32.184)/86400;
