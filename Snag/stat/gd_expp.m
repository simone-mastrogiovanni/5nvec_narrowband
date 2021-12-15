function g=gd_expp(sig,dx,xmax,int)
%GD_EXPP  exponential distribution with added signal
%
%    sig   added signal (quadratic - energy)
%    dx    sampling
%    xmax  max abscissa
%    int   type of distribution
%           = 1 -> comulative distribution
%           = 2 -> integral distribution

%x=(dx/2):dx:xmax;
x=(dx/2):dx:(2*xmax);
n=length(x);
s=sqrt(sig);
pi4=4*pi;

y1=(1./sqrt(pi4*x)).*exp(-x);
y2=(1./sqrt(pi4*x)).*exp(-(sqrt(x)-s).^2);
a1=sum(y1)*dx;
a2=sum(y2)*dx;
y1=y1/a1;y2=y2/a2;

ep=conv(y1,y2)*dx;
if int == 1
   ep=cumsum(ep)*dx;
end
if int == 2
   ep=1-cumsum(ep)*dx;
end

n2=ceil(n/2);
ep=ep(1:n2);

g=gd(n2);
g=edit_gd(g,'dx',dx,'ini',0,'capt','distr exp+sig','y',ep);