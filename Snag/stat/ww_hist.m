function [wwh,out]=ww_hist(wtyp,hwid,data,weight,noplot)
% window & weight histogram
%
%   wwh=ww_hist(wtyp,hwid,data,weight)
%
%   wtyp      window type (0 rectangular, 1 triangular, 2 cosine, 3 exponential, 4 gaussian)
%   hwid      window half-width; if 2 values, wid(2) number of samples in hwid (def 20)
%             if 4 values, [hwid nsamp minx maxx]
%   data      array or gd
%   weight    if present, weigth of each datum (0 -> no)
%   noplot    > 0 -> no plot

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('noplot','var')
    noplot=0;
end
if isa(data,'gd')
    data=y_gd(data);
end
if ~exist('weight','var')
    weight=data*0+1;
end

if length(weight) == 1
    weight=data*0+1;
end

if length(hwid) >= 2
    n=hwid(2);
else
    n=20;
end
hwid0=hwid;
hwid=hwid(1);
dx=hwid/n;

nn=2*n+1;

switch wtyp
    case 0
        y=ones(1,nn);
        y(1)=0.5;
        y(nn)=0.5;
    case 1
        y(1:n+1)=1:n+1;
        y(nn:-1:n+2)=y(1:n);
    case 2
        y(1:n+1)=cos((-n:0)*pi/(2*n));
        y(nn:-1:n+2)=y(1:n);
    case 3
        y(n+1:nn)=exp(-(0:n)/(n/3));
        y(1:n)=y(nn:-1:n+2);
    case 4
        y(n+1:nn)=exp(-(((0:n)/(n/2)).^2)/2);
        y(1:n)=y(nn:-1:n+2);
end

y=y/sum(y);
% figure,plot(y),grid on
out.y=y;

mind=min(data);
maxd=max(data);

if length(hwid0) > 2
    mind=hwid0(3);
    maxd=hwid0(4);
end

nd=length(data);

N=ceil(n*(maxd-mind)/hwid+2*n)+2;
h=zeros(1,N);
ini=mind-hwid*(n+1)/n;

for i = 1:nd
    ii=round((data(i)-ini)/dx)+1;
    h(ii-n:ii+n)=h(ii-n:ii+n)+y*weight(i);
end

wwh=gd(h);
wwh=edit_gd(wwh,'ini',ini,'dx',dx);
h=h/sum(h);
x=x_gd(wwh);
mu=sum(x.*h');
sig=sqrt(sum((x-mu).^2.*h'));
asim=sum((x-mu).^3.*h')/sig^3;
curt=sum((x-mu).^4.*h')/sig^4-3;
fprintf('mu = %f  sig = %f  asim = %f  curt = %f \n',mu,sig,asim,curt)
out.mu=mu;
out.sigma=sig;
out.skewness=asim;
out.curtosis=curt;

if noplot == 0
    figure,plot(wwh);
end