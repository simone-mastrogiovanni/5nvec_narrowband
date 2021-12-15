function display(g)
%GD/DISPLAY display a gd2

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

st=sprintf('%d',g.n);
in=sprintf('%d',g.ini);
dx=sprintf('%d',g.dx);
st2=sprintf('%d',g.m);
in2=sprintf('%d',g.ini2);
dx2=sprintf('%d',g.dx2);
typ=sprintf('%d',g.type);

disp([' gd2 ',inputname(1),' -> n=',st,' inix=',in,' dx=',dx,...
   ' m=',st2,' ini2=',in2,' dx2=',dx2,' type=',typ,' -> ',g.capt])