function [P,p,out]=enl_hist2prob(hh,xh,X,left,right,pmod,ipl)
% probability function from histogram, enlarged on the sides and spline at center
%
%   hh     histogram
%   xh     hist abscissa (uniform) 
%   X      requested abscissas
%   left   .llim left limit abscissa; x <= X(1) no left enlargement
%          .typ 'pow'
%          .par power
%   right  .rlim right limit abscissa; x >= X(last) no right enlargement
%          .typ 'chisq'
%          .par dof
%   pmod   1 pdf, 2 cdf, 3 icdf
%   ipl    plot 0 no (def), 1 plot, 2 semilogx, 3 semilogy, 4 loglog

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('ipl','var')
    ipl=0;
end

n=sum(hh);
dx=xh(2)-xh(1);
DX=X(2)-X(1);

p=hh/(n*dx);

x1=left.llim;
pow=left.par;
ii=find(xh < x1);
i1=length(ii)+1;
x1=xh(i1-1);
y1=p(i1-1);
A1=y1/x1^pow;

x2=right.rlim;
dof=right.par;
ii=find(xh < x2);
i2=length(ii)+1;
x2=xh(i2);
y2=p(i2);
const=6; % ?
x2c=x2*const;
A2=y2/(x2c.^(dof/2-1)*exp(-x2c/2));

N=length(X);

ii=find(X < x1);
I1=length(ii)+1;
ii=find(X <= x2);
I2=length(ii);

out.l=[x1,y1,i1,I1];
out.r=[x2,y2,i2,I2];

Y(1:I1-1)=A1*X(1:I1-1).^pow;
Y(I1:I2)=spline(xh,p,X(I1:I2));
x=X(I2+1:N)*const;
Y(I2+1:N)=A2*x.^(dof/2-1).*exp(-x/2);

P=Y;

switch pmod
    case 2
        p=cumsum(p)*dx;
        P=cumsum(P)*DX;
    case 3
        p=cumsum(p,'reverse')*dx;
        P=cumsum(P,'reverse')*DX;
end

switch ipl
    case 1
        plot(xh,p),grid on
    case 2
        semilogx(xh,p),grid on
    case 3
        semilogy(xh,p),grid on
    case 4
        loglog(xh,p),grid on
end