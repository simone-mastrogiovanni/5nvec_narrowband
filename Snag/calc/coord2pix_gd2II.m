function [kx ky]=coord2pix_gd2II(xg,yg,x,y)
% coord2pix_gd2II computes discrete indices from coordinates
%                 similar to coord2pix_gd2
%
%   xg    primary gd2 abscissa
%   yg    secondary gd2 abscissa
%   x     primary requested abscissa
%   y     secondary requested abscissa

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(x);
m=length(xg);
m2=length(yg);
ini2=yg(1);
dx2=yg(2)-yg(1);

for i = 1:n
    xx=x(i);
    if xx < xg(1)
        kx(i)=1;
    elseif xx >= xg(m)
        kx(i)=m;
    else
        for j = 1:m-1
            if xx >= xg(j) && xx < xg(j)+1
                if xx-xg(j) < xg(j)-xx
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
ky=round((y-ini2)/dx2);
i=find(ky<1);
ky(i)=1;
i=find(ky>m2);
ky(i)=m2;