function g=gd_atan3(c)
%ANALYSIS\ATAN3  computes atan3 (in number of turns; 1 turn = 360 degrees)
%
%       g=gd_atan3(c)
%
%      c   a complex gd
%

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=c;
y=y_gd(c);
y=atan3(y);
g=edit_gd(g,'y',y,'addcapt','atan3 on:');