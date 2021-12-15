function g=multy2gd_gd(g,y)
%GS/MULTY2GD_GD  produces a gd from many doubles
%
% used to produce, for example, a gd from a ds
%
% the lengths of the gd is set before the call
% the gd must be of type 1
% 
% typical use:
%     ...
%    definition of sp, gd and ds
%     ...
%    cont=0;
%    len=ngd(g);
%    while cont < len
%       d=ds_noise(d,'spect',sp);  % the ds source
%       y=yds(d);
%       g=multy2gd(g,y);
%       cont=contgd(g);
%    end

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ld=length(y);
lg=g.n;
cont=g.cont;

max=cont+ld;
ld1=ld;
if max > lg
   ld1=ld-(max-lg);
   max=lg;
end

g=w_gd(g,cont+1,max,y(1:ld1));
g.cont=max;
