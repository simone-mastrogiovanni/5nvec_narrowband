function gout=power(gin,pow)
% POWER  power for gds
%  
%     gout=power(gin,pow)
% 
%      or   gin.^pow

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

gout.capt=['power of ' gout.capt];

gout.y=power(gout.y,pow);