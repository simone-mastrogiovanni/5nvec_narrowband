function radpat_sky(source,antenna,tsid)
%RADPAT_SKY     interferometric detector response as a function of source
%position
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
%   tsid       sidereal time (hour)
%

% July 2003, C. Palomba
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nalpha=100;
Ndelta=100;

i1 = 1:1:Nalpha;
source.a = (i1-1)*360/Nalpha;
i2 = 1:1:Ndelta;
source.d = -90+(i2-1)*180/Ndelta;
 
g=radpat_interf(source,antenna,tsid);
image(source.a,source.d,g,'CDataMapping','scaled');
colormap;
colorbar;