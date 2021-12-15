function imap_gd2(m)
%IMAP_GD2   simplified map of a gd2

[na,nd]=size(m.y);

dx=m.dx;
dy=m.dx2;

x1=m.ini;
x2=x1+(m.n/m.m-1)*dx;

y1=m.ini2;
y2=y1+(m.m-1)*dy;

x=[x1 x2];
y=[y1 y2];
d0=floor(nd/2);

m1=m.y';

figure;
image(m1,'XData',x,'YData',y,'CDataMapping','scaled');
%set(gco,'YDir','reverse'); % NON FUNZIONA
colorbar; % sporca la finestra di pss_explorer
colormap cool;
grid on;zoom on;
%drawnow