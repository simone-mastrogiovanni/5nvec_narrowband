function [x,y,z]=twod_peaksII(A,thresh,n,res)
%TWOD_PEAKS  finds the n highest peaks in a gd2 or matrix
%
%   A        input gd2 or matrix
%   thresh   threshold
%   n        maximum number of peaks (0 -> all)
%   res      resolution [res1 res2]

% Version 2.0 - July 2012
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
if length(res) < 2
    res(2)=res;
end
res=round(res);
if res(1) < 1
    res(1)=1;
end
if res(2) < 1
    res(2)=1;
end

mm=min(A(:));
B=zeros(n1+2*res(1),n2+2*res(2))+mm;
B(res+1:n1+res(1),res(2)+1:n2+res(2))=A;
iii=0;

for i = res(1)+1:n1+res(1)
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
        b=B(i-res(1):i+res(1),jj-res(2):jj+res(2));
        b=max(b(:));
        if B(i,jj) == b
            iii=iii+1;
            ii1=i-res(1);
            x1(iii)=xx(ii1);
            ix(iii)=ii1;
            ii2=jj-1-res(2);
            y1(iii)=ii2*dx2+ini2;
            iy(iii)=ii2;
            z1(iii)=b;
        end
    end
end

if exist('z1','var')
    [z1,iz]=sort(z1,'descend');
    x1=x1(iz);
    y1=y1(iz);

    if n > 0
        n=min(n,length(x1));
        
        x(1)=x1(1);
        ixx(1)=ix(1);
        y(1)=y1(1);
        iyy(1)=iy(1);
        z(1)=z1(1);
        itot=1;
        ii=1;
        
        while itot < n
            ii=ii+1;
            ix1=ix(ii);
            iy1=iy(ii);
            new=1;
            for i = 1:itot
%                 fprintf('%d %d %d %d %d \n',ii,ixx(i),ix1,iyy(i),iy1)
                if abs(ixx(i)-ix1) <= res(1) && abs(iyy(i)-iy1) <= res(2)
                    new=0;
                    fprintf('%d excluded\n',ii)
                    break
                end
            end
            
            if new == 1
                itot=itot+1;
                x(itot)=x1(ii);
                ixx(itot)=ix1;
                y(itot)=y1(ii);
                iyy(itot)=iy1;
                z(itot)=z1(ii);
            end
        end
    end
else
    x=[];
    y=[];
    z=[];
end