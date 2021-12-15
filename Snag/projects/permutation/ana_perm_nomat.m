function [net,cycs,pcyc,p]=ana_perm_nomat(p)
% ANA_PERM  analyzes a permutation (element periods)
%
%    [lord,net]=ana_perm(p)
%
%  p   permutation

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if length(p) == 1
    p=sn_perm(p);
end

n=length(p);
f=1:n;
f1=f;
lord=zeros(1,n);
zer=lord;

for i = 1:n
    f=f(p);
    lord(i)=sum(f==f1);
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

cycs=find(net);
% lastcyc=n-sum(cycs)
% if lastcyc > 0
%     cycs(length(cycs)+1)=lastcyc;
% end
cycs
pcyc=lcm_arr(cycs)

sum(net)