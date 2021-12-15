%LAB_PLOT  interactive plot of dat from lab file 
%
% Operation:
%   - choose axes option (default x,y linear, zoom on, grid on);
%     every setting of log or linear resets the plot;
%     also the limits of the axes can be set interactively 
%   - choose a new lab file from the data menu (you can plot more data sets)
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

% Project LabMec - part of the toolbox Snag - April 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[t,s,dt,n]=leggi_pasco;

h0scra = figure('Color',[1 1 0.7], ...
   'Name','Lab Plot',...
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
ch_absc_sum=0;
ch_absc_mult=1;
ic_startx_from0=0;

gdcom=strcat('xfig=t;yfig=s;',...
  'xfig=xfig*ch_absc_mult+ch_absc_sum-floor(ic_startx_from0*xfig(1));',...
  'npscra=npscra+1;tcol=rotcol(npscra);',...
  'switch iclinlog;',...
  'case 0;plot(xfig,yfig,''color'',tcol);',...
  'case 1;semilogx(xfig,yfig,''color'',tcol);',...
  'case 2;semilogy(xfig,yfig,''color'',tcol);',...
  'case 3;loglog(xfig,yfig,''color'',tcol);',...
  'case 4;plot(xfig,yfig,''.'',''color'',tcol);',...
  'case 5;semilogx(xfig,yfig,''.'',''color'',tcol);',...
  'case 6;semilogy(xfig,yfig,''.'',''color'',tcol);',...
  'case 7;loglog(xfig,yfig,''.'',''color'',tcol);',...
  'case 8;plot(xfig,yfig,''x'',''color'',tcol);',...
  'case 9;semilogx(xfig,yfig,''x'',''color'',tcol);',...
  'case 10;semilogy(xfig,yfig,''x'',''color'',tcol);',...
  'case 11;loglog(xfig,yfig,''x'',''color'',tcol);',...
  'end;hold on;grid on;zoom on;');
eval(gdcom)

contmenuh=uimenu(h0scra,'label','Axes');

uimenu(contmenuh,'label','x,y linear','callback','iclinlog=0;hold off;npscra=0;');
uimenu(contmenuh,'label','x log','callback','iclinlog=1;hold off;npscra=0;');
uimenu(contmenuh,'label','y log','callback','iclinlog=2;hold off;npscra=0;');
uimenu(contmenuh,'label','x,y log','callback','iclinlog=3;hold off;npscrascra=0;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x,y linear - "."','callback','iclinlog=4;hold off;npscra=0;');
uimenu(contmenuh,'label','x log - "."','callback','iclinlog=5;hold off;npscra=0;');
uimenu(contmenuh,'label','y log - "."','callback','iclinlog=6;hold off;npscra=0;');
uimenu(contmenuh,'label','x,y log - "."','callback','iclinlog=7;hold off;npscrascra=0;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x,y linear - "x"','callback','iclinlog=8;hold off;npscra=0;');
uimenu(contmenuh,'label','x log - "x"','callback','iclinlog=9;hold off;npscra=0;');
uimenu(contmenuh,'label','y log - "x"','callback','iclinlog=10;hold off;npscra=0;');
uimenu(contmenuh,'label','x,y log - "x"','callback','iclinlog=11;hold off;npscrascra=0;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','x,y limits','callback','axesdlg(h1axgdpl);');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','change x unit','callback','[ch_absc_sum,ch_absc_mult]=ch_absc(ini_gd(gdx)),hold off');
uimenu(contmenuh,'label','start x from 0','callback','ic_startx_from0=1;hold off;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','zoom on','callback','zoom on;');
uimenu(contmenuh,'label','zoom off','callback','zoom off;');
uimenu(contmenuh,'label','grid on','callback','grid on;');
uimenu(contmenuh,'label','grid off','callback','grid off;');

labmenu(h0scra);

contmenuh2=uimenu(h0scra,'label','Other');

uimenu(contmenuh2,'label','integral','callback',...
   'ginproc(''integral'',xfig,yfig);');
uimenu(contmenuh2,'label','quick spectrum','callback',...
   'ginproc(''spectrum'',xfig,yfig);');
uimenu(contmenuh2,'label','quick histogram','callback',...
   'ginproc(''histogram'',xfig,yfig);');

