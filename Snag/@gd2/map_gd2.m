function map_gd2(m)
%MAP_GD2   interactive map of a gd2

global m2_gd2m min2_gd2m max2_gd2m dh_gd2m lmin2_gd2m lmax2_gd2m dhl_gd2m;
global m1_gd2m xx_gd2m yy_gd2m mx_gd2m my_gd2m x_gd2m y_gd2m;

[na,nd]=size(m.y);

dx=m.dx;
dy=m.dx2;

x1=m.ini;
x2=x1+(m.n/m.m-1)*dx;

y1=m.ini2;
y2=y1+(m.m-1)*dy;

x_gd2m=[x1 x2];
y_gd2m=[y1 y2];
d0=floor(nd/2);

m1_gd2m=m.y';
mx_gd2m=mean(m1_gd2m,1);
my_gd2m=mean(m1_gd2m,2);
xx_gd2m=linspace(x1,x2,length(mx_gd2m));
yy_gd2m=linspace(y1,y2,length(my_gd2m));
m2_gd2m=m1_gd2m(:);
min2_gd2m=min(m2_gd2m);
max2_gd2m=max(m2_gd2m);
lmin2_gd2m=log10(abs(min2_gd2m));
lmax2_gd2m=log10(abs(max2_gd2m));
dh_gd2m=(max2_gd2m-min2_gd2m)/200;
dhl_gd2m=(lmax2_gd2m-lmin2_gd2m)/200;

h0scra = figure('Color',[1 1 0.7], ...
   'Name','gd2 Map');

dismenuh=uimenu(h0scra,'label','Display');

uimenu(dismenuh,'label','Normal','callback',...
   'global m1_gd2m x_gd2m y_gd2m;image(m1_gd2m,''XData'',x_gd2m,''YData'',y_gd2m,''CDataMapping'',''scaled'');colorbar;colormap cool;grid on;zoom on;');
uimenu(dismenuh,'label','Log','callback',...
   'global m1_gd2m x_gd2m y_gd2m;image(log10(pre_log(m1_gd2m)),''XData'',x_gd2m,''YData'',y_gd2m,''CDataMapping'',''scaled'');colorbar;colormap cool;grid on;zoom on;');
uimenu(dismenuh,'label','Square Root','callback',...
   'global m1_gd2m x_gd2m y_gd2m;image(sqrt(pre_sqrt(m1_gd2m)),''XData'',x_gd2m,''YData'',y_gd2m,''CDataMapping'',''scaled'');colorbar;colormap cool;grid on;zoom on;');
uimenu(dismenuh,'label','Contour plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;contourf(xx,yy,m1,7);');
uimenu(dismenuh,'label','Log contour plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;contourf(xx_gd2m,yy_gd2m,log10(pre_log(m1_gd2m)),7);');
uimenu(dismenuh,'label','Square root contour plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;contourf(xx_gd2m,yy_gd2m,sqrt(pre_sqrt(m1_gd2m)),7);');
uimenu(dismenuh,'label','3D plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;waterfall(xx_gd2m,yy_gd2m,m1_gd2m);');
uimenu(dismenuh,'label','Log 3D plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;waterfall(xx_gd2m,yy_gd2m,log10(pre_log(m1_gd2m)));');
uimenu(dismenuh,'label','Square root 3D plot','callback',...
   'global m1_gd2m xx_gd2m yy_gd2m;waterfall(xx_gd2m,yy_gd2m,sqrt(pre_sqrt(m1_gd2m)));');
uimenu(dismenuh,'label','Change color map','callback',...
   'colormap_sel;');


opmenuh=uimenu(h0scra,'label','Operations');

uimenu(opmenuh,'label','Histogram','callback',...
   'global m2_gd2m min2_gd2m max2_gd2m dh_gd2m;figure;hist(m2_gd2m,min2_gd2m:dh_gd2m:max2_gd2m);');
uimenu(opmenuh,'label','Log Histogram','callback',...
   'global m2_gd2m lmin2_gd2m lmax2_gd2m dhl_gd2m;figure;hist(log10(pre_log(m2_gd2m)),lmin2_gd2m:dhl_gd2m:lmax2_gd2m);');
uimenu(opmenuh,'label',' ');
uimenu(opmenuh,'label','x projection','callback',...
   'global xx_gd2m yy_gd2m mx_gd2m my_gd2m;figure;plot(xx_gd2m,mx_gd2m),grid on,title(''x projection'')');
uimenu(opmenuh,'label','y projection','callback',...
   'global xx_gd2m yy_gd2m mx_gd2m my_gd2m;figure;plot(yy_gd2m,my_gd2m),grid on,title(''y projection'')');
uimenu(opmenuh,'label','x projection (log)','callback',...
   'global xx_gd2m yy_gd2m mx_gd2m my_gd2m;figure;semilogy(xx_gd2m,mx_gd2m),grid on,title(''x projection (log)'')');
uimenu(opmenuh,'label','y projection (log)','callback',...
   'global xx_gd2m yy_gd2m mx_gd2m my_gd2m;figure;semilogy(yy_gd2m,my_gd2m),grid on,title(''y projection (log)'')');
uimenu(opmenuh,'label','Superimposed plot','callback',...
   'global m1_gd2m x_gd2m y_gd2m;plot(m1_gd2m),grid on;');
uimenu(opmenuh,'label','Superimposed log plot','callback',...
   'global m1_gd2m x_gd2m y_gd2m;semilogy(pre_log(m1_gd2m)),grid on;');

image(m1_gd2m,'XData',x_gd2m,'YData',y_gd2m,...
   'CDataMapping','scaled');
%set(gco,'XDir','reverse'); % NON FUNZIONA
colorbar;
colormap ;
grid on;zoom on;