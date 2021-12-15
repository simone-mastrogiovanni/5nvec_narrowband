function evch=gui_evch(evch)
%GUI_EVCH
%

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ch=evch.ch;

ch=gui_ech(ch);
evch.ch=ch;