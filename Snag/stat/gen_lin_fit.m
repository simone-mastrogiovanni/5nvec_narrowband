function [a,covar,F,res,chiq,ndof,err,errel,wres,wsnr]=gen_lin_fit(x,y,unc,ic,par,ipl)
% GEN_LIN_FIT  general linear fit
%
%   [a,covar,F,res,chiq,ndof,err,errel]=gen_lin_fit(x,y,unc,ic,par,ipl)
%
%   x      abscissa value (length n) or gd
%   y      ordinate value (length n) or nothing
%   unc    y uncertainty (length n; if single number, all equal)
%   ic     type of linear fit:
%              0  ->  general;    par the matrix [n,M]
%              1  ->  polynomial; par the order
%              2  ->  sinusoidal (bias and trend for fr=0); par the frequencies
%   par    polynomial degree
%   ipl    = 1 -> plot
%
%   a      fit parameters (length M) (in case of pol of deg k, M=k+1 the
%           coeff a are in descending order)
%   covar  covariance matrix
%   F      base functions
%   res    residuals
%   chiq   chi-square value
%   ndof   degrees of freedom
%   err    mean square error
%   errel  mean square relative error

% Version 2.0 - April 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isobject(x)
    y=y_gd(x);
    x=x_gd(x);
end

n=length(x);

if length(unc) == 1
    const=unc;
    unc(1:n)=const;
end

if ~exist('ipl','var')
    ipl=0;
end

x=x(:);y=y(:);unc=unc(:);

switch ic
    case 0
        A=par;
        [n,M]=size(A);
    case 1
        M=par+1;
        for i = 0:par
            A(:,i+1)=x.^(par-i);
        end
    case 2
        nfr=length(par);
        M=nfr*2;
        ii=0;
        for i = 1:nfr
            if par(i) == 0
                A(1:n,ii+1)=1;
                A(:,ii+2)=x;
            else
                A(:,ii+1)=cos(2*pi*par(i)*x);
                A(:,ii+2)=sin(2*pi*par(i)*x);
            end
            ii=ii+2;
        end
end

F=A;
for i = 1:M
    A(:,i)=A(:,i)./unc;
end
y1=y./unc;

B=A.'*A;
b=A.'*y1;

covar=inv(B);
a=covar*b;

chiq=sum((y1-A*a).^2);
ndof=n-M;

y2=F*a;
% err=sqrt(sum((y-y2).^2)/n);
% errel=sqrt(sum((y-y2).^2)/n)/sqrt(sum(y.^2)/n);
res=y2-y;

for i = 1:n
    f=F(i,:);
    err(i)=f*covar*f';
end

err=sqrt(err);
err=sqrt(sum(err.^2)/n);
errel=err/sqrt(sum(y.^2)/n);

wres=sqrt(sum((res.^2)./unc.^2)/sum(1./unc.^2));
wsnr=(max(y2)-min(y2))/wres;

if ipl > 0
    figure,plot(F),grid on,title('base functions')
    figure,plot(x,y,'.'),hold on,plot(x,y2,'r'),grid on,title('fit')
    figure,plot(x,res,'.'),grid on,title('residuals')
end