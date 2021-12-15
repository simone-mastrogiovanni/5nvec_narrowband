function cycs=find_maxcycles(N)
% FIND_MAXCYCLES  finds the cycles that maximize a permutation cycle
%
%     N    order of the permutation

s=primes(5*sqrt(N));

ss=cumsum(s); % figure,loglog(ss),grid on

[i1,i2]=find(ss<N);

cycs=s(i2);
pp=prod(cycs)
ss=sum(cycs);
lastcyc=N-ss;

if lastcyc > 0
    cycs(length(cycs)+1)=lastcyc;
end
