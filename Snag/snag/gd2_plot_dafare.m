%GD2_PLOT   interactive map of a gd2

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
x=mean(m1,1);
y=mean(m1,2);
m2=m1(:);
min2=min(m2)
max2=max(m2);
lmin2=log10(abs(min2));
lmax2=log10(abs(max2));
dh=(max2-min2)/200;
dhl=(lmax2-lmin2)/200;

h0scra = figure('Color',[0.8 0.8 0.8], ...
   'Name','gd2 Map');

contmenuh=uimenu(h0scra,'label','Operations');

uimenu(contmenuh,'label','Histogram','callback','hist(m2,min2:dh:max2);');
uimenu(contmenuh,'label','Log Histogram','callback','hist(log10(m2),lmin2:dhl:lmax2);');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x projection','callback','iclinlog=2;hold off;npscra=0;');
uimenu(contmenuh,'label','y projection','callback','iclinlog=3;hold off;npscrascra=0;');

image(m1,'XData',x,'YData',y,'CDataMapping','scaled');
%set(gco,'XDir','reverse'); % NON FUNZIONA
colorbar;
colormap cool;
grid on;zoom on;