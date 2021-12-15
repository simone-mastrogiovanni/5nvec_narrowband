function x=log_absc(mina,maxa,n)
%LOG_ABSC   creates a vector of dimension n, logarithmically spaced
%           between mina and maxa
%

% Version 1.0 - April 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2001  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


d=(maxa/mina)^(1/(n-1));

x=0:n-1;

x=mina*d.^x;