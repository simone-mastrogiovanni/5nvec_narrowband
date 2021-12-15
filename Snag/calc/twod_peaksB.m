function [x,y,z]=twod_peaks(A,thresh,n,res,verb)
%TWOD_PEAKS  finds the n highest peaks in a gd2 or matrix
%
%   A        input gd2 or matrix
%   thresh   threshold
%   n        maximum number of peaks (0 -> all)
%   res      resolution [res1 res2]
%   verb     verbosity

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('verb','var')
    verb=0;
end
if isobject(A)
    xx=x_gd2(A);
    dx2=dx2_gd2(A);
    ini2=ini2_gd2(A);
    A=y_gd2(A);
%     [n1,n2]=size(A);
else
    [n1,n2]=size(A);
    xx=1:n1;
    ini2=1;
    dx2=1;
end

if ~exist('thresh','var')
    thresh=max(max(A))/2;
end

if ~exist('n','var')
    n=0;
end
if ~exist('res','var')
    res=1;
end
res=round(res);
if length(res) < 2
    res(2)=res;
end
res=round(res);
res=res+1;
% if res(1) < 1
%     res(1)=1;
% end
% if res(2) < 1
%     res(2)=1;
% end

peaks=row_2Dpeaks(A,thresh);
[i1 j1 z1]=find(peaks);

if exist('z1','var')
    lz1=length(z1);
    n=min(n,lz1);

    [z1,iz]=sort(z1,'descend');
    i1=i1(iz);
    j1=j1(iz);
    
    x=zeros(1,n);
    ix=x;y=x;iy=x;z=x;

    if n > 0
        n=min(n,length(z1));
        
        x(1)=xx(i1(1));
        ix(1)=i1(1);
        y(1)=j1(1)*dx2+ini2;
        iy(1)=j1(1);
        z(1)=z1(1);
        itot=1;
        ii=1;
        
        while itot < n && ii < lz1
            ii=ii+1; % disp([n itot ii])
            ix1=i1(ii);
            iy1=j1(ii);
            z11=z1(ii);
            new=1;
            for i = 1:itot
%                 fprintf('%d %d %d %d %d \n',ii,ixx(i),ix1,iyy(i),iy1)
                if abs(ix(i)-ix1) <= res(1) && abs(iy(i)-iy1) <= res(2)
                    new=0;
                    if z11 > z(i)
                        x(i)=xx(ix1);
                        ix(i)=ix1;
                        y(i)=iy1*dx2+ini2;
                        iy(i)=iy1;
                        z(i)=z11;
                        fprintf('%d substitutes\n',ii)
                    else
                        fprintf('%d excluded\n',ii)
                    end
                    
                    break
                end
            end
            
            if new == 1
                itot=itot+1;
                x(itot)=xx(i1(ii));
                ix(itot)=ix1;
                y(itot)=j1(ii)*dx2+ini2;
                iy(itot)=iy1;
                z(itot)=z1(ii);
            end
        end
    end
else
    x=[];
    y=[];
    z=[];
end

if exist('itot','var')
    x=x(1:itot);
    y=y(1:itot);
    z=z(1:itot);
    if verb > 0
        for i = 1:itot
            fprintf('%d:  %f  %f  (%d  %d)   %f \n',i,x(i),y(i),ix(i),iy(i),z(i))
        end
    end
end