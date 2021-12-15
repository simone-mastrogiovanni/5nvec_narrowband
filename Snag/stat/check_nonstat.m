function sout=check_nonstat(x,tau)
% CHECK_NONSTAT  checks for non-stationarities with spectral methods
%
%    out=check_nonstat(x,tau)
%
%  x     input data
%  tau   basic piece data (in samples)

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N=length(x);
n=floor(N*2/tau)-1;
sout=zeros(1,n);
i0=1;

for i = 1:n
    i1=floor(i*tau/2);
    xx=x(i0:i1);
    i0=round((i0+i1)/2);
    sout(i)=std(xx);
end

f=abs(fft(sout-mean(sout))).^2;
figure,loglog(f(2:ceil(length(f)/2))),grid on