function [m s]=ar_ext_array(d,tau)
% AR_EXT_ARRAY  autoregressive extimation array
%
%    [m s]=ar_ext_array(d,tau)
%
%  d     sampled data
%  tau   tau values (in samples)
%
%  m     mean
%  s     standard deviation

% Version 2.0 - June 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(d);
nt=length(tau);
m=zeros(n,nt);
s=m;

for i = 1:nt
    w=exp(-1./tau(i));
    x=ones(1,n);
    N=filter(1,[1 -w],x);
    M=filter(1,[1 -w],d);
    m(:,i)=M./N;
%     x=d-m(:,i);
%     Q=filter(1,[1 -w],x.*x);
%     s(:,i)=sqrt(Q./N);
    Q=filter(1,[1 -w],d.*d);
    s(:,i)=sqrt((Q-M.*M./N)./N);
end