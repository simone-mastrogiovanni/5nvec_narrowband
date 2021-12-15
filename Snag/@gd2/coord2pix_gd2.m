function [kx ky]=coord2pix_gd2(gin,x,y)
% coord2pix_gd2 computes discrete indices from coordinates
%                     NOT OPTIMIZED
%
%   gin   input gd2
%   x     primary abscissa
%   y     secondary abscissa

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(x);
xg=gin.x;
m=length(xg);

for i = 1:n
    xx=x(i);
    if xx < xg(1)
        kx(i)=1;
    elseif xx >= xg(m)
        kx(i)=m;
    else
        for j = 1:m-1
            if xx >= xg(j) && xx < x(j)+1
                if xx-xg(j) < x(j) -xx
                    kx(i)=j;
                else
                    kx(i)=j+1;
                end
                break
            end
        end
    end
end

n=length(y);
ky=round((y-gin.ini2)/gin.dx2);
i=find(ky<1);
ky(i)=1;
i=find(ky>gin.m);
ky(i)=gin.m;