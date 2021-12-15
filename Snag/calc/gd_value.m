function y=gd_value(gin,x)
% gd_value  computes the y value for a given x

% Version 2.0 - September 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(x);
y=x*0;

xx=x_gd(gin);
yy=y_gd(gin);
N=length(xx);

for i = 1:n
    if x(i) <= xx(1)
        y(i)=yy(1);
        continue
    end
    if x(i) >= xx(N)
        y(i)=yy(N);
        continue
    end
    [mi im]=min(abs(x(i)-xx));
    is=sign(x(i)-xx(im));
    if is == 0
        is=1;
    end
    
    x1=xx(im);
    x2=xx(im+is);
    y1=yy(im);
    y2=yy(im+is);
    y(i)=y1+((y2-y1)/(x2-x1))*(x(i)-x1);
end
    