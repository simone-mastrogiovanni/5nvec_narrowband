function [sfpar,covar,F,res,chiq,ndof,err,errel]=sid_fit(gin,comp,ipl)
% fit for sidereal sources
%
%     [sfpar sf]=sid_fit(gin,comp)
%
%    gin    input gd
%    comp   components [1 1 1 1 1]; def [1 1 0 0 0]
%           first   sidereal year
%           second  sidereal day
%           third   first spin-down
%           fourth  second spin-down
%           fifth   third spin-down
%            ...
%    ipl    > 0 -> plot (default)
%
%   sfpar  fit parameters (length M)
%   covar  covariance matrix
%   F      base functions
%   res    residuals
%   chiq   chi-square value
%   ndof   degrees of freedom
%   err    mean square error
%   errel  mean square relative error

% Version 2.0 - November 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('ipl','var')
    ipl=1;
end

if ~exist('comp','var')
    comp=[1 1 0 0 0];
end

if length(comp) < 5
    l=length(comp);
    comp=[comp zeros(1,5-l)];
end

nsid=find(comp(1:2));
nsd=find(comp(3:length(comp)));
nsid=length(nsid);
nsd=length(nsd);
nfit=nsid*2+nsd+1;

sidy=1/365.256363004;
sidd=1/0.99726958;

y=y_gd(gin);
x=x_gd(gin);

n=length(x);
t0=x(1);
mu=mean(y);
y=y-mu;

F=zeros(n,nfit);

ii=1;
F(:,ii)=ones(n,1);
ii=ii+1;

if comp(1) > 0
    F(:,ii)=cos(2*pi*sidy*(x-t0));
    F(:,ii+1)=sin(2*pi*sidy*(x-t0));
    ii=ii+2;
end

if comp(2) > 0
    F(:,ii)=cos(2*pi*sidd*(x-t0));
    F(:,ii+1)=sin(2*pi*sidd*(x-t0));
    ii=ii+2;
end

for j = 3:length(comp)
    if comp(j) > 0
        F(:,ii)=(x-t0).^(j-2);
        ii=ii+1;
    end
end

B=F.'*F;
b=F.'*y;

covar=inv(B);
a=covar*b;
%a=B\b;

chiq=sum((y-F*a).^2);
ndof=n-nfit;

y2=F*a;
res=y2-y;

for i = 1:n
    f=F(i,:);
    err(i)=f*covar*f';
%     err(i)=f*B\f';
end

err=sqrt(err);
err=sqrt(sum(err.^2)/n);
errel=err/sqrt(sum(y.^2)/n);

if ipl > 0
    figure,plot(F),grid on,title('base functions')
    figure,plot(x,y,'.'),hold on,plot(x,y2,'r'),grid on,title('fit')
    figure,plot(x,res,'.'),grid on,title('residuals')
end

sfpar=zeros(length(comp)+2,1);
sfpar(1)=a(1)+mu;

ii=1;
fprintf('Bias = %f \n',sfpar(1))
ii=ii+1;

if comp(1) > 0
    sfpar(2)=sqrt(a(ii).^2+a(ii+1).^2);
    sfpar(3)=atan2d(a(ii+1),a(ii));
    fprintf('Sid.Year periodicity: amp = %f,  phase = %d\n',sfpar(2),sfpar(3))
    ii=ii+2;
end

if comp(2) > 0
    sfpar(4)=sqrt(a(ii).^2+a(ii+1).^2);
    sfpar(5)=atan2d(a(ii+1),a(ii));
    fprintf('Sid.Day periodicity: amp = %f,  phase = %d\n',sfpar(4),sfpar(5))
    ii=ii+2;
end

for j = 3:length(comp)
    if comp(j) > 0
        sfpar(5-2+j)=a(ii);
        fprintf('Polynomial coefficient power %d = %f \n',j-2,sfpar(5-2+j))
        ii=ii+1;
    end
end

a