function d=galac_disc(a)
%GALAC_DISC galactical disc coordinates
%
%          d=galac_disc(a)
%
%    a   right ascension values
%    d   declination values

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

deg2rad=pi/180;
d=sin((a-282.85)*deg2rad)*62.9;