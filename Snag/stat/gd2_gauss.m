function g=gd2_gauss(xrange,yrange,mux,muy,sigx,sigy,ro)
%GD2_GAUSS  2-D gaussian
%
%    xrange                 [xmin,xmax,nx]
%    yrange                 [ymin,ymax,ny]
%    mux,muy,sigx,sigy,ro   parameters

% Version 2.0 - September 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

xmin=xrange(1);
xmax=xrange(2);
nx=xrange(3);

ymin=yrange(1);
ymax=yrange(2);
ny=yrange(3);

dx=(xmax-xmin)/(nx-1);
dy=(ymax-ymin)/(ny-1);

x=xmin+(0:nx-1).*dx;
y=ymin+(0:ny-1).*dy;

coe=(1/(2*pi*sigx*sigy*sqrt(1-ro^2)));
expo0=zeros(nx,ny);
for i = 1:nx
    for j = 1:ny
        expo0(i,j)=(x(i)-mux).^2/sigx^2-(2*ro/(sigx*sigy))*(x(i)-mux).*(y(j)-muy)+(y(j)-muy).^2/sigy^2;
    end
end
expo=-(1/(2*(1-ro^2)))*expo0;

g=coe*exp(expo);

g=gd2(g);
g=edit_gd2(g,'n',nx*ny,'m',ny,'ini',xmin,'ini2',ymin,'dx',dx,'dx2',dy,'capt','2D gaussian');