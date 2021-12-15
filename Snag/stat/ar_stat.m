%GD_STAT  statistics of gds
%
% Operation:
%   - choose control items
%      > new parameters      choice of the range (default min,max)
%      > hold parameters     override the default
%      > normalized          frequency
%      > non normalized      histogram
%      > zoom on, zoom off   (default zoom on)
%      > grid on, grid off   (default grid on)
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

% Version 2.0 - September 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

h0scra = figure('Color',[1 1 0.7], ...
   'Name','gd Statistics',...
	'Position',[232 288 560 420]);
h1scra = axes('Parent',h0scra, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

listdouble;

nmenu=gdol.n;
gdmenuh=uimenu(h0scra,'label','array');
nphIst=0;
icdefhist=0;
icgdsnorm=0;

for i = 1:nmenu
   gdsscra=gdol.name{i};
   gdcom=strcat('gdx=',gdsscra,...
      ';ystat=real(gdx(:));',...
      'if icdefhist == 0;',...
        '[yfig,xfig]=hist(ystat,200);',...
      'elseif icdefhist == 1;',...
        'xsTat=histdlg(ystat);',...
        '[yfig,xfig]=hist(ystat,xsTat);',...
        'icdefhist=2;',...
      'elseif icdefhist == 2;',...
        '[yfig,xfig]=hist(ystat,xsTat);',...
      'end;',...
      'if icgdsnorm == 1;',...
        'yfig=yfig/(length(ystat)*(xfig(2)-xfig(1)));',...
      'end;',...
      'nphIst=nphIst+1;tcol=rotcol(nphIst);',...
      '[Xfig,Yfig]=tostairs(xfig,yfig);mystat=mean(ystat);stystat=std(ystat);',...
      'mstr=sprintf(''%g'',mystat);sstr=sprintf(''%g'',stystat);',...
      'disp([''  mean = '',mstr,'', st.dev. = '',sstr]);',...
      'h2scra = line(''Parent'',h1scra,''Color'',tcol,''XData'',Xfig,''YData'',Yfig);',...
      'grid on;zoom on;');
   uimenu(gdmenuh,'label',gdsscra,'callback',gdcom);
end

contmenuh=uimenu(h0scra,'label','Control');

uimenu(contmenuh,'label','new parameters','callback','hold off;icdefhist=1;');
uimenu(contmenuh,'label','hold parameters','callback','icdefhist=2;');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','normalized','callback','icgdsnorm=1;');
uimenu(contmenuh,'label','no normalized','callback','icgdsnorm=0;');
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
