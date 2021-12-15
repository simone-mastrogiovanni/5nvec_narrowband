function gout=log(gin)
% LOG  log for gds
%  
%     gout=log(gin)
%

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

gout.capt=['log of ' gout.capt];

gout.y=log(gout.y);