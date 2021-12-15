function a=bselect(s,b,c)
%BSELECT  binary selection
%
% a = b   if s > 0
% a = c   elsewhere

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=floor((sign(s)+1)/2);
a=a*b+(1-a)*c;