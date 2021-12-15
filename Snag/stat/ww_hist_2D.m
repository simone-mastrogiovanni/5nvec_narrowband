function [wwh,out]=ww_hist_2D(wtyp,hwid,data,weight)
% window & weight histogram
%
%   wwh=ww_hist(wtyp,hwid,data,weight)
%
%   wtyp      1 or 2 components; window type (0 rectangular, 1 triangular, 2 cosine, 3 exponential, 4 gaussian)
%   hwid      2 components; window half-width; 
%   data      (2,nd)-matrix 
%   weight    (nd) if present, weigth of each datum

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(wtyp) == 1
    wtyp(2)=wtyp;
end
if ~exist('weight','var')
    weight=data(1,:)*0+1;
end

n=10;
dx1=hwid(1)/n;
dx2=hwid(2)/n;

nn=2*n+1;

switch wtyp(1)
    case 0
        y1=ones(1,nn);
        y1(1)=0.5;
        y1(nn)=0.5;
    case 1
        y1(1:n+1)=1:n+1;
        y1(nn:-1:n+2)=y1(1:n);
    case 2
        y1(1:n+1)=cos((-n:0)*pi/(2*n));
        y1(nn:-1:n+2)=y1(1:n);
    case 3
        y1(n+1:nn)=exp(-(0:n)/(n/3));
        y1(1:n)=y1(nn:-1:n+2);
    case 4
        y1(n+1:nn)=exp(-(((0:n)/(n/2)).^2)/2);
        y1(1:n)=y1(nn:-1:n+2);
end

switch wtyp(2)
    case 0
        y2=ones(1,nn);
        y2(1)=0.5;
        y2(nn)=0.5;
    case 1
        y2(1:n+1)=1:n+1;
        y2(nn:-1:n+2)=y2(1:n);
    case 2
        y2(1:n+1)=cos((-n:0)*pi/(2*n));
        y2(nn:-1:n+2)=y2(1:n);
    case 3
        y2(n+1:nn)=exp(-(0:n)/(n/3));
        y2(1:n)=y2(nn:-1:n+2);
    case 4
        y2(n+1:nn)=exp(-(((0:n)/(n/2)).^2)/2);
        y2(1:n)=y2(nn:-1:n+2);
end

y=zeros(nn,nn);

for i = 1:nn
    y(:,i)=y1*y2(i);
end

y=y/sum(y(:));
out.y=y;
% figure,plot(y),grid on

mind1=min(data(1,:));
maxd1=max(data(1,:));
mind2=min(data(2,:));
maxd2=max(data(2,:));
nd=length(data);

N1=ceil(n*(maxd1-mind1)/hwid(1)+2*n)+2;
N2=ceil(n*(maxd2-mind2)/hwid(2)+2*n)+2;
h=zeros(N1,N2);
ini1=mind1-hwid(1)*(n+1)/n;
ini2=mind2-hwid(2)*(n+1)/n;

for i = 1:nd
    ii1=round((data(1,i)-ini1)/dx1)+1;
    ii2=round((data(2,i)-ini2)/dx2)+1;
    for j = 0:nn-1
        h(ii1-n:ii1+n,ii2-n+j)=h(ii1-n:ii1+n,ii2-n+j)+y(:,j+1)*weight(i);
    end
end

wwh=gd2(h);
wwh=edit_gd2(wwh,'ini',ini1,'dx',dx1,'ini2',ini2,'dx2',dx2);
% h=h/sum(h);
% x=x_gd(wwh);
% mu=sum(x.*h');
% sig=sqrt(sum((x-mu).^2.*h'));
% asim=sum((x-mu).^3.*h')/sig^3;
% curt=sum((x-mu).^4.*h')/sig^4-3;
% fprintf('mu = %f  sig = %f  asim = %f  curt = %f \n',mu,sig,asim,curt)
% out.mu=mu;
% out.sigma=sig;
% out.skewness=asim;
% out.curtosis=curt;

plot(wwh);