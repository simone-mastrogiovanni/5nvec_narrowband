function g=fr2gd(file,adc,ini,nfr)
%FR2GD puts frame data in a GD
%
%    g=fr2gd(file,adc,ini,nfr)
%
%    file
%    adc channel
%    ini   initial frame
%    nfr   number of frames

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[a,t,f,t0,t0s,c,u,more] = frextrsnag1(file,adc,ini,nfr);

g=gd(a);
%dt=t(2)-t(1);
dt=more(6);
g=edit_gd(g,'dx',dt,'capt',file);
