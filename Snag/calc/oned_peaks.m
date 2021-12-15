function [x,z,ii]=oned_peaks(A,thresh,n,res)
%ONED_PEAKS  finds the n highest peaks in a gd or array
%
%   [x,z]=oned_peaks(A,thresh,n,res
%
%   A        input gd or array
%   thresh   threshold (negative threshold -> no sort)
%   n        maximum number of peaks (0 -> all)
%   res      resolution
%
%   x        peak abscissa
%   z        peak amplitude

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ii=[];
x=[];
z=[];
if isobject(A)
    xx=x_gd(A);
    A=y_gd(A);
    n1=length(A);
else
    n1=length(A);
    xx=1:n1;
end

if ~exist('n')
    n=0;
end
if ~exist('res')
    res=1;
end
res=round(res);
if res < 1
    res=1;
end
nosort=0;
if thresh < 0
    thresh=-thresh;
    nosort=1;
end

mm=min(A);
B=zeros(n1+2*res,1)+mm;
B(res+1:n1+res)=A;
iii=0;

b1=rota(B,1);
b2=rota(B,-1);
b1=ceil(sign(B-b1)/2);
b2=ceil(sign(B-b2)/2+0.1);
b1=b1.*b2;
b=B.*b1;
b2=ceil(sign(b-thresh)/2);
b=b.*b2;
bb=find(b);
for j = 1:length(bb)
    jj=bb(j);
    if jj < 2
        continue
    end
    b=B(jj-res:jj+res);
    [b,ii]=max(b(:));
    if B(jj) == b
        iii=iii+1;
        x(iii)=xx(jj-res);
        z(iii)=b;
    end
end

ii=ii-res;

if nosort == 0
    [z,iz]=sort(z,'descend');
    x=x(iz); 
end

if n > 0
    n=min(n,length(x));
    x=x(1:n);
    z=z(1:n);
    ii=ii(1:n);
% else
%     x=[];
%     z=[];
end