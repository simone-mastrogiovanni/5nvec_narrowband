function [sig,sigmf,mf,pdist,pzero,t1]=check_gauss_ns1(a,den,len)
% CHECK_GAUSS_NS  checks for the presence of a (disturbed)gaussian process
%                  - non-stationary way
%
%   [sig,sigmf,mf,pdist,pzero]=check_gauss_ns1(a,den,len)
%
%    a        the data (array or gd)
%    den      density of log bins (bins per unit interval)
%    len      
%
%    t1
%    sig      dev.st. from mean
%    sigmf    dev.st. from matched filter
%    mf       value of the matched filter (normalized to 1 for a gaussian process)
%    pdist    disturbance fraction

% Version 2.0 - June 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isobject(a)
    t=x_gd(a);
    a=y_gd(a);
else
    t=0:length(a)-1;
end

a=a(:);
N0=length(a);
NN=floor(N0*2/len)-2;

sig=zeros(NN,1);
sigmf=sig;
mf=sig;
pdist=sig;
pzero=sig;
t1=sig;

len2=floor(len/2);
NN0=0;
ii=0;

while NN0 < N0-len
    ii=ii+1;
    t1(ii)=mean(t(NN0+1:NN0+len));
    chunk=a(NN0+1:NN0+len);
    NN0=NN0+len2;
    [sig(ii),sigmf(ii),mf(ii),pdist(ii),pzero(ii)]=check_gauss(chunk,den);
end

t10=t1-floor(t1(1));
figure,plot(t10,sig),hold on,grid on
plot(t10,sigmf,'r'),plot(t10,sigmf,'.')
figure,plot(t10,mf),hold on,plot(t10,mf,'r.'),grid on
figure,semilogy(t10,pdist,'r'),hold on,semilogy(t10,pdist,'.'),semilogy(t10,pzero,'g'),semilogy(t10,pzero,'.'),grid on