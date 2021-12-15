function gintext
%GINTEXT  puts text on a plot; used by ginmenu

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

str=inputdlg('text to add ?','Adding text to plot',1);
gtext(str);