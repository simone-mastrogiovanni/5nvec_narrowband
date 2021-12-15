function h=histoint(arr,n,type)
%HISTOINT  integral histogram of an array
%
%  h=histoint(arr,n,type)
%
%   arr   the array of data
%    n    number of bins
%   type  'log' or 'lin'

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
if type == 'log'
   semilogy(X,Y);
else
   plot(X,Y);
end

grid on;zoom on;