function [x,y,z]=twod_peaksI(A,thresh,n,res)
%TWOD_PEAKS  finds the n highest peaks in a gd2 or matrix
%                     (old procedure)
%
%   A        input gd2 or matrix
%   thresh   threshold
%   n        maximum number of peaks (0 -> all)
%   res      resolution

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isobject(A)
    xx=x_gd2(A);
    dx2=dx2_gd2(A);
    ini2=ini2_gd2(A);
    A=y_gd2(A);
    [n1,n2]=size(A);
else
    [n1,n2]=size(A);
    xx=1:n1;
    ini2=1;
    dx2=1;
end

if ~exist('thresh','var')
    thresh=max(max(A))/2
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

mm=min(A(:));
B=zeros(n1+2*res,n2+2*res)+mm;
B(res+1:n1+res,res+1:n2+res)=A;
iii=0;

for i = res+1:n1+res
    b=B(i,:);
    b1=rota(b,1);
    b2=rota(b,-1);
    b1=ceil(sign(b-b1)/2);
    b2=ceil(sign(b-b2)/2+0.1);
    b1=b1.*b2;
    b=b.*b1;
    b2=ceil(sign(b-thresh)/2);
    b=b.*b2;
    bb=find(b);
    for j = 1:length(bb)
        jj=bb(j);
        if jj < 2
            continue
        end
        b=B(i-res:i+res,jj-res:jj+res);
        b=max(b(:));
        if B(i,jj) == b
            iii=iii+1;
            x(iii)=xx(i-res);
            y(iii)=(jj-1-res)*dx2+ini2;
            z(iii)=b;
        end
    end
end

if exist('z','var')
    [z,iz]=sort(z,'descend');
    x=x(iz);
    y=y(iz);

    if n > 0
        n=min(n,length(x));
        x=x(1:n);
        y=y(1:n);
        z=z(1:n);
    end
else
    x=[];
    y=[];
    z=[];
end