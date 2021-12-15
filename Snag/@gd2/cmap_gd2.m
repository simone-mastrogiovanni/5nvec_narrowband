function cmap_gd2(m)
%CMAP_GD2    maps a gd2 with contourf

[na,nd]=size(m.y);

dx=m.dx;
dy=m.dx2;

x1=m.ini;
x2=x1+(m.n/m.m-1)*dx;

y1=m.ini2;
y2=y1+(m.m-1)*dy;

x=x1:dx:x2;
y=y1:dy:y2;
d0=floor(nd/2);

m1=m.y';

figure;
contourf(x,y,m1,7);
colorbar;
colormap cool;
grid on;zoom on;