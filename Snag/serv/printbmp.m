function printbmp
%PRINTPS  prints in a bitmap file (with the name of the date)
%         the last opened graph

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=clock;
ye=sprintf('%d',a(1));
mo=sprintf('%d',a(2));
da=sprintf('%d',a(3));
ho=sprintf('%d',a(4));
mi=sprintf('%d',a(5));
se=sprintf('%d',floor(a(6)));
a=strcat('print -dbitmap ml',ye,mo,da,ho,mi,se,'.bmp');
eval(a);