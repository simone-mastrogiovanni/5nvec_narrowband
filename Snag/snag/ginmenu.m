function ginmenu(h0)
%GINMENU  activates the graphical input menu

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

contmenuh=uimenu(h0,'label','Graph Input');

uimenu(contmenuh,'label','value','callback','ginproc(''value'');');
uimenu(contmenuh,'label','distance','callback','ginproc(''distance'');');
uimenu(contmenuh,'label','slope','callback','ginproc(''slope'');');
uimenu(contmenuh,'label','"exponent" slope','callback','ginproc(''logslope'');');
uimenu(contmenuh,'label','"tau" slope','callback','ginproc(''ylogslope'');');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','3 point exp slope','callback','ginproc(''3pexpsl'');');
uimenu(contmenuh,'label','3 point circle','callback','ginproc(''3pcircle'');');
uimenu(contmenuh,'label','polynomial fit','callback','ginproc(''polyfit'');');
uimenu(contmenuh,'label','y-log polynomial fit','callback','ginproc(''pfylog'');');
uimenu(contmenuh,'label','log-log polynomial fit','callback','ginproc(''pfloglog'');');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','add text','callback','gintext;');