function v=gen_logunif(n,range)
% GEN_LAPLACE  generates log-uniform distributed data
%
%      v=gen_logunif(n)
%
%   n      number of generated data
%   range  [min,max] value (positive)

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

xmin=log(range(1));
xmax=log(range(2));

set_random
v=exp(xmin+rand(1,n)*(xmax-xmin));