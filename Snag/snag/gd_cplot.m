%GD_CPLOT  plots of complex gds 
%
% Operation:
%   - chose "What" option (default "imag vs real"):
%      > imag vs real
%      > real part
%      > imag part
%      > absolute value
%      > phase  (uses angle)
%      > atan3  (uses atan3)
%   - choose axes option (default x,y linear, zoom on, grid on);
%     every setting of log or linear resets the plot;
%     also the limits of the axes can be set interactively 
%   - choose a gd from the gd menu (you can plot more gds)
%   - use the "Graph Input" menu item to do interactive measures on the plot:
%      > value               the x,y value of the cross hair
%      > distance            distance for two points
%      > slope               the "slope" for two points
%      > exponent            exponent k in y=x^k model
%      > tau                 the tau in y=A*exp(x/tau) model
%      > 3 point exp slope   three points exponential slope; the three points
%                            should be about equispaced on the abscissa
%      > 3 point circle      radius and center of a circle for three points
%      > polynomial fit      polinomial fit for n points
%      > y-log polyn. fit    y-logarithmic polynomial fit
%      > loglog polyn fit    xy-logarithmic polynomial fit
%      > add text            add text interactively
%   - use "Other" menu for miscelaneous operations; examples:
%      > integral            computes the integral in a chosen range of the x

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

h0scra = figure('Color',[1 1 0.7], ...
   'Name','gd Complex Plot',...
	'Position',[232 288 560 420]);
h1axgdcpl = axes('Parent',h0scra, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

listgd;

nmenu=gdol.n;
gdmenuh=uimenu(h0scra,'label','gd');
npscra=0;
iclinlog=0;
iccomplex=0;

for i = 1:nmenu
   gdsscra=gdol.name{i};
   gdcom=strcat('gdx=',gdsscra,...
      ';switch iccomplex;',...
      'case 0;xfig=real(y_gd(gdx));yfig=imag(y_gd(gdx));',...
      'case 1;xfig=x_gd(gdx);yfig=real(y_gd(gdx));',...
      'case 2;xfig=x_gd(gdx);yfig=imag(y_gd(gdx));',...
      'case 3;xfig=x_gd(gdx);yfig=abs(y_gd(gdx));',...
      'case 4;xfig=x_gd(gdx);yfig=angle(y_gd(gdx));',...
      'case 5;xfig=x_gd(gdx);yfig=atan3(y_gd(gdx));',...
      'end;npscra=npscra+1;tcol=rotcol(npscra);',...
      'switch iclinlog;',...
      'case 0;plot(xfig,yfig,''color'',tcol);',...
      'case 1;semilogx(xfig,yfig,''color'',tcol);',...
      'case 2;semilogy(xfig,yfig,''color'',tcol);',...
      'case 3;loglog(xfig,yfig,''color'',tcol);',...
      'end;hold on;grid on;zoom on;');
   uimenu(gdmenuh,'label',gdsscra,'callback',gdcom);
end

contmenuh1=uimenu(h0scra,'label','What');

uimenu(contmenuh1,'label','imag vs real','callback','iccomplex=0;hold off;npscra=0;');
uimenu(contmenuh1,'label','real part','callback','iccomplex=1;hold off;npscra=0;');
uimenu(contmenuh1,'label','imag part','callback','iccomplex=2;hold off;npscra=0;');
uimenu(contmenuh1,'label','absolute value','callback','iccomplex=3;hold off;npscra=0;');
uimenu(contmenuh1,'label','phase','callback','iccomplex=4;hold off;npscra=0;');
uimenu(contmenuh1,'label','atan3','callback','iccomplex=5;hold off;npscra=0;');

contmenuh=uimenu(h0scra,'label','Axes');

uimenu(contmenuh,'label','x,y linear','callback','iclinlog=0;hold off;npscra=0;');
uimenu(contmenuh,'label','x log','callback','iclinlog=1;hold off;npscra=0;');
uimenu(contmenuh,'label','y log','callback','iclinlog=2;hold off;npscra=0;');
uimenu(contmenuh,'label','x,y log','callback','iclinlog=3;hold off;npscra=0;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x,y limits','callback','axesdlg(h1axgdcpl);');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','zoom on','callback','zoom on;');
uimenu(contmenuh,'label','zoom off','callback','zoom off;');
uimenu(contmenuh,'label','grid on','callback','grid on;');
uimenu(contmenuh,'label','grid off','callback','grid off;');

ginmenu(h0scra);

contmenuh2=uimenu(h0scra,'label','Other');

uimenu(contmenuh2,'label','integral','callback',...
   'ginproc(''integral'',xfig,yfig);');
uimenu(contmenuh2,'label','print postscript','callback','printps;');


