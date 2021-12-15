function ast=agmst(t)
%AGMST  Anti-Greenwich mean sidereal time (in hours)
%
%   t   time (in mjd)
%

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

% fr=2-1.002737909350795;
% ast=mod(-3.717381+fr*t*24,24);

t=t-v2mjd([2000 1 1 12 0 0]);
asid=-282.6974395092493+23.934290175580919*t;
ast=mod(asid,24);
