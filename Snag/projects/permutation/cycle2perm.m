function p=cycle2perm(cycs)
% CYCLE2PERM  constructs a permutation from the e-cycles

N=sum(cycs);
n=length(cycs);
p=2:N+1;
i0=0;

for i = 1:n
   p(cycs(i)+i0)=i0+1;
   i0=i0+cycs(i);
end
