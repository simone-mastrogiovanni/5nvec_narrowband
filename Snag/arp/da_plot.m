%DA_PLOT  plots of double arrays

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

h0scra = figure('Color',[0.8 0.8 0.8], ...
   'Name','double arrays Plot',...
	'Position',[232 288 560 420]);
h1axdpl = axes('Parent',h0scra, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

listdoublearray;

nmenu=doubleol.n;
dmenuh=uimenu(h0scra,'label','double array');
npscra=0;
iclinlog=0;

for i = 1:nmenu
   gdsscra=doubleol.name{i};
   gdcom=strcat('yfig=',gdsscra,';lfigscra=length(eval(gdsscra));',...
      'xfig=1:lfigscra;npscra=npscra+1;tcol=rotcol(npscra);',...
      'switch iclinlog;',...
      'case 0;plot(xfig,yfig,''color'',tcol);',...
      'case 1;semilogx(xfig,yfig,''color'',tcol);',...
      'case 2;semilogy(xfig,yfig,''color'',tcol);',...
      'case 3;loglog(xfig,yfig,''color'',tcol);',...
      'end;hold on;');
   uimenu(dmenuh,'label',gdsscra,'callback',gdcom);
end

dcontmenuh=uimenu(h0scra,'label','Axes');

uimenu(dcontmenuh,'label','x,y linear','callback','iclinlog=0;hold off;npscra=0;');
uimenu(dcontmenuh,'label','x log','callback','iclinlog=1;hold off;npscra=0;');
uimenu(dcontmenuh,'label','y log','callback','iclinlog=2;hold off;npscra=0;');
uimenu(dcontmenuh,'label','x,y log','callback','iclinlog=3;hold off;npscrascra=0;');
uimenu(dcontmenuh,'label',' ');
uimenu(dcontmenuh,'label','x,y limits','callback','axesdlg(h1axdpl);');
uimenu(dcontmenuh,'label',' ');
uimenu(dcontmenuh,'label','zoom on','callback','zoom on;');
uimenu(dcontmenuh,'label','zoom off','callback','zoom off;');
uimenu(dcontmenuh,'label','grid on','callback','grid on;');
uimenu(dcontmenuh,'label','grid off','callback','grid off;');

contmenuh2=uimenu(h0scra,'label','Other');

uimenu(contmenuh2,'label','print postscript','callback','printps;');
