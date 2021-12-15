function display(g)
%GDADV/DISPLAY display a gdadv

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

st=sprintf('%d',g.n);
in=sprintf('%d',g.ini);
dx=sprintf('%d',g.dx);
ty=sprintf('%d',g.type);
con=' ';
if isa(g.cont,'double')
    if g.cont ~= 0
        con=sprintf(' cont= %f',g.cont);
    end
end
    
disp([' gdadv ',inputname(1),' -> n=',st,' ini=',in,' dx=',dx,...
   ' type=',ty,con,' -> ',g.capt])