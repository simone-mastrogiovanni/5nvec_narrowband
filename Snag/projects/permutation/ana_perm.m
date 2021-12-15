function [lord,net]=ana_perm(p)
% ANA_PERM  analyzes a permutation (element periods)
%
%    [lord,net]=ana_perm(p)
%
%  p   permutation or perm matrix

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(p);
[i1,i2]=size(p);
if i1*i2 == n %| n == 1
    p=perm2mat(p);
end

n=length(p);
f=eye(n);
lord=zeros(1,n);
zer=lord;

for i = 1:n
    f=f*p;
    lord(i)=trace(f);
end

net=lord;
pr=1:n/2;
npr=length(pr);

for i = 1:npr
    nn=net(pr(i));
    if nn > 0
        elem=2*pr(i):pr(i):n;
        subtr=zer;
        subtr(elem)=nn;
        net=net-subtr;
    end
end

sum(net)