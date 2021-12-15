function radpat_time(source,antenna,nstep)
%RADPAT_TIME    interferometric detector response as a function of time
%
%   antenna:     antenna structure
%           .lat    longitude (deg)
%           .long   latitude (deg)
%           .azim   azimuth (deg) (detector x-arm, from south to west)
%           .incl   inclination (deg) (to be implemented)
%
%   source      source structure
%           .a      right ascension (degree)
%           .d:     declination (degree)
%           .psi    linear polarization angle
%           .eps    percentage of linear polarization
%
%   nstep       number of time step
%

% July 2003, C. Palomba
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsid=(0:nstep-1)*24/nstep;

g=radpat_interf(source,antenna,tsid);
plot(tsid,g);