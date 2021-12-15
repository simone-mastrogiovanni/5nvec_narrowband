function p=sqrt_1_perm(n,typ)
% SQRT_1_PERM  creates a permutation that is a square root of the identity
%
%    p=sqrt_1_perm(n,typ)  
%
%  n     order
%  typ   1 only permutation, otherwise matrix (default)

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random

if ~exist('typ','var')
    typ=0;
end

r=rand(1,n);
nout=n;
lout=1:n;
ii=1;
p=zeros(1,n);

while nout > 1
    kout(1)=1;
    kout(2)=ceil(r(ii)*nout);
    p(lout(1))=lout(kout(2));
    p(lout(kout(2)))=lout(1);
    [lout,nout]=dlist_out(lout,kout);
    ii=ii+1;
end

if nout == 1
    p(lout)=lout;
end

if typ ~= 1
    p=perm2mat(p);
end