function m=perm2mat(p)
% PERM2MAT  creates a matrix from a permutation
%
%    m=perm2mat(p)
%
%  p   permutation (if length(p)=1, p is the order and the perm is created)

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if length(p) == 1
    set_random

    i=rand(1,p);
    [i,p]=sort(i);
end

n=length(p);
j=p;
i=1:n;
s=j*0+1;

m=sparse(i,j,s,n,n);