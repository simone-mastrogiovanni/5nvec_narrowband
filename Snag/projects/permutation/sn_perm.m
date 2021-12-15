function iout=sn_perm(n)
% SN_PERM  random permutation (a row vector)
%
%    iout=sn_perm(n)
%
%  n   order of the permutation

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random

i=rand(1,n);
[i,iout]=sort(i);