function [x hang hsp]=study_hsphere(n,ndim,typ,bias)
% STUDY_HSPHERE creates and studies hypersphere surface points
%
%    x=study_hsphere(n,ndim,typ,bias)
%
%   n      number of points
%   ndim   number of sphere dimension
%   typ    type ('norm','unif',...)
%   bias   bias
%
%   x(ndim,n)  point coordinates
%   hang       histograms of angles with the axes
%   hsp        histogram of scalar products between all the points

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('typ','var')
    typ='norm';
end

if ~exist('bias','var')
    bias=0;
end

x=zeros(ndim,n);
hang=zeros(1,101);
h=hang;

for i = 1:n
    switch typ
        case 'unif'
            c=rand(1,ndim)-0.5+bias;
        case 'norm'
            c=randn(1,ndim)+bias;
    end
    c=c/sqrt(c*c');
    x(:,i)=c;
    for j = 1:ndim
        ic=ceil(acos(c(j))*100/pi+eps);
        hang(ic)=hang(ic)+1;
        ic1=ceil(c(j)*50+51);
        h(ic1)=h(ic1)+1;
    end
end

nhang=sum(hang);
hang=hang*100/nhang;
figure,plot((0:100)*3.6,hang),grid on
title(sprintf('Angle distribution - ndim = %d',ndim))

nh=sum(h);
h=h*100/nh;
figure,plot((-50:50)*0.02,h),grid on
title(sprintf('Scalar prod distribution - ndim = %d',ndim))

% distance

hsp=zeros(1,2001);
m=0;q=0;
corr=0;aa=0;
% corr1=0;m1=0;q1=0;

for i = 1:n-1
    if floor(i/100)*100 == i
        disp(i)
    end
    for j=i+1:n
        a=sum(x(:,i).*x(:,j));
        m=m+a;
        q=q+a*a;
        corr=corr+a*aa;
%         corr1=corr1+abs(a*aa);
%         m1=m1+abs(a);
        aa=a;
        ia=round(a*1000+1001);
        hsp(ia)=hsp(ia)+1;
    end
end

nn=n*(n-1)/2;
media=m/nn
var=(q-m*m/nn)/nn;
devst=sqrt(var)
corr=corr/(nn*var)
% var1=(q-m1*m1/nn)/nn;
% mediabs=m1/nn
% devstabs=sqrt(var1)
% corrabs=(corr1-m1*m1/nn)/(nn*var1)
nhsp=sum(hsp);
hsp=1000*hsp/nhsp;
figure,plot((-1000:1000)/1000,hsp),grid on
title(sprintf('Scalar product distribution - ndim = %d',ndim))