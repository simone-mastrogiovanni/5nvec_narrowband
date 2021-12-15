function v=gen_laplace(n)
% GEN_LAPLACE  generates Laplace distributed data
%
%      v=gen_laplace(n)
%
%   n   number of generated data

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random
v=rand(1,n)-0.5;
v=-sign(v).*log(1-2*abs(v));