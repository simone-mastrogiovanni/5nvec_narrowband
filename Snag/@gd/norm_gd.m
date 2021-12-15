function g=norm_gd(gin)
%NORM_GD  normalizes the peak value of a gd

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=max(abs(y_gd(gin)));
g=gin/a;