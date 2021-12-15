function [d,ring]=inifr2ds(dlen,type,ringlen)
%INIFR2DS  initializes a ds of length len and an rg, of length 2 times the length
%          of a frame, to be used for fr2ds
%
%        [d,ring]=inifr2ds(dlen,type,ringlen)
%
%     dlen      ds length
%     type      type (0,1,2)
%     ringlen   ring length

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=ds(dlen);
d=edit_ds(d,'type',type);
ring=rg(ringlen);