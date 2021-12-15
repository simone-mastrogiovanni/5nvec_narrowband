function [corr,distr]=corr_bootstrap(in1,in2,n,nbins)
%CORR_BOOTSTRAP  evaluates the correlation with bootstrap method
%
%    corr     correlation coefficient
%    distr    correlation distribution
%
%    in1,in2  input series
%    n        number of permutations
%    nbins    number of bins in the histogram

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

in1=in1-mean(in1);
in2=in2-mean(in2);
sd1=std(in1);
sd2=std(in2);
nin=length(in1);
norm=((nin-1)*sd1*sd2);
if norm == 0
    norm=1;
else
    norm=1/norm;
end
nmax=factorial(nin);
if n > nmax
    disp('to much iterations')
    n=nmax
end

corr=sum(in1.*in2)*norm
hi=zeros(nbins,1);
nbins2=nbins/2;
n34=34;

for i = 1:n
    r=rand(n34*nin,1);
    r1=floor(rand(nin,1)*(n34-1));
    [r,ind]=sort(r((1:n34:nin*n34)+r1'));
    co=sum(in1(ind).*in2)*norm;
    j=ceil((co+1)*nbins2);
    if j < 1
        j=1;
    end
    hi(j)=hi(j)+1;
end

icorr=floor((corr+1)*nbins2);
p=sum(hi(icorr:nbins))/sum(hi)
dx=1/nbins2;
distr=gd(hi);
distr=edit_gd(distr,'ini',-1,'dx',dx);