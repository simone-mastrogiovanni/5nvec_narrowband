function h=gd_histoint(g,n,type)
%HISTOINT  integral histogram of a gd
%
%  h=gd_histoint(g,n,type)
%
%    g    the gd
%    n    number of bins
%   type  'log' or 'lin'

arr=y_gd(g);
x1=min(arr(:));
x2=max(arr(:));
x2=x2+2*(x2-x1)/n;
kx=linspace(x1,x2,n+2);

ky=hist(arr(:),kx);
ky=fliplr(ky);
ky=cumsum(ky);
ky=fliplr(ky);
h=ky;
ky(length(ky))=0.5;
ky(length(ky)-1)=0.5;
[X,Y]=tostairs(kx,ky);
figure
if type == 'log'
   semilogy(X,Y);
else
   plot(X,Y);
end

grid on;zoom on;