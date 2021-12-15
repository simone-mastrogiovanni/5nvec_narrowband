function snag_plot(xQwEr,yQwEr)
%SNAG_PLOT  interactive plot of data
%
%    snag_plot(x,y)
%
%  Only from the prompt of matlab; not from functions
%
% Operation:
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

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

global xQwEr yQwEr iclinlog

h0scra = figure('Color',[1 1 0.7], ...
   'Name','gd Plot',...
	'Position',[232 288 560 420]);
h1axgdpl = axes('Parent',h0scra, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);

npscra=0;
iclinlog=0;

com=strcat('global xQwEr yQwEr;',...
   'xfig=xQwEr;yfig=yQwEr;npscra=npscra+1;tcol=rotcol(npscra);',...
   'switch iclinlog;',...
   'case 0;plot(xfig,yfig,''color'',tcol);',...
   'case 1;semilogx(xfig,yfig,''color'',tcol);',...
   'case 2;semilogy(xfig,yfig,''color'',tcol);',...
   'case 3;loglog(xfig,yfig,''color'',tcol);',...
   'end;hold on;grid on;zoom on;');

eval(com)

contmenuh=uimenu(h0scra,'label','Axes');

uimenu(contmenuh,'label','x,y linear','callback',...
   ['global iclinlog;iclinlog=0;hold off;npscra=0;' com]);
uimenu(contmenuh,'label','x log','callback',...
   ['global iclinlog;iclinlog=1;hold off;npscra=0;' com]);
uimenu(contmenuh,'label','y log','callback',...
   ['global iclinlog;iclinlog=2;hold off;npscra=0;' com]);
uimenu(contmenuh,'label','x,y log','callback',...
   ['global iclinlog;iclinlog=3;hold off;npscra=0;' com]);
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x,y limits','callback','axesdlg(h1axgdpl);');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','zoom on','callback','zoom on;');
uimenu(contmenuh,'label','zoom off','callback','zoom off;');
uimenu(contmenuh,'label','grid on','callback','grid on;');
uimenu(contmenuh,'label','grid off','callback','grid off;');

ginmenu(h0scra);

contmenuh2=uimenu(h0scra,'label','Other');

uimenu(contmenuh2,'label','integral','callback',...
   'global xQwEr yQwEr;ginproc(''integral'',xQwEr,yQwEr);');
uimenu(contmenuh2,'label','quick spectrum','callback',...
   'global xQwEr yQwEr;ginproc(''spectrum'',xQwEr,yQwEr);');
uimenu(contmenuh2,'label','quick histogram','callback',...
   'global xQwEr yQwEr;ginproc(''histogram'',xQwEr,yQwEr);');
uimenu(contmenuh2,'label','print postscript','callback','printps;');

