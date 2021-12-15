function out=mc_rank_coin(N,R,n,M)
% simulation of rank_coin procedure
%
%   out=mc_rank_coin(N,R,n)
%
%   N     number of coin for each sub-band (if it is a scalar, fixed)
%   R     correlation for each sub-band (if it is a scalar, fixed)
%   n     number of subbands (if absent, this is the size of N and/or R)

% Version 2.0 - ASeptember 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('M','var')
    M=10;
end
nN=length(N);
nR=length(R);
nn=max(nN,nR);

if nn > 1
    n=nn;
end

if nN == 1
    N=ones(n,1)*N;
end

if nR == 1
    R=ones(n,1)*R;
end

Pmc=zeros(n,1);
Pmc1=zeros(n,M);
Rmc=Pmc;

for i = 1:M
    for j = 1:n     
        x=corr_unif(N(j),R(j));

        Pmc(j)=min(x(:,1).*x(:,2));
%         a=corrcoef(x);
%         Rmc(i)=Rmc(i)+a(1,2);
    end
    
    [Pmc,jj]=sort(Pmc);
    Pmc1(:,i)=Pmc;
end

for j = 1:n
    out.Pmc(j)=mean(Pmc1(j,:));
    out.sdPmc(j)=std(Pmc1(j,:));
end
