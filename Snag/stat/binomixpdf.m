function [f mu sig f1 mu1 sig1]=binomixpdf(N,p,M)
% BINOMIXPDF  distribution of a mixing of binomial process
%
%     [f mu sig f1 mu1 sig1]=binomixpdf(N,p,M)
%
%   N         value of N
%   p         array of ps
%   M         array of Ms
%
%   f         distribution
%   mu,sig    distribution parameters
%   f1        mean p distribution
%   mu1,sig1  mean p distribution parameters  

% Version 2.0 - January 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(p);
MM=sum(M);
f=zeros(1,N+1);

for i = 1:n
    f=f+M(i)*binopdf(0:N,N,p(i));
end

f=f/MM;

xx=(0:N);
mu=sum(f.*xx)
sig=sqrt(sum(((xx-mu).^2).*f))
pp=sum(p.*M)/MM
f1=binopdf(0:N,N,pp);
mu1=pp*N
sig1=sqrt(pp*(1-pp)*N)

f2=normpdf(xx,mu,sig);

figure,plot(xx,f),hold on,plot(xx,f2,'g'),plot(xx,f1,'r'),grid on