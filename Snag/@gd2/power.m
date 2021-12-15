function gout=power(gin,pow)
% POWER  power for gd2s
%  
%     gout=power(gin,pow)
%

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics -  Sapienza Rome University

gout=gin;

gout.capt=[num2str(pow) ' power of ' gout.capt];

gout.y=gout.y.^pow;