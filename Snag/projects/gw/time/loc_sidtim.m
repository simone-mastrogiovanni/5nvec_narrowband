function lst=loc_sidtim(mjd,long)
% local sidereal time in hours
%
%    lst=loc_sidtim(mjd,long)
%
%   mjd     time (mjd or jd)
%   long    longitude (deg, measured eastward) 

% Snag version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

lst=mod(gmst(mjd)+long/15,24);