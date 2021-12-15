function gout=sqrt(gin)
% SQRT  sqrt for gds
%  
%     gout=sqrt(gin)
%

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

gout.capt=['sqrt of ' gout.capt];

gout.y=sqrt(gout.y);