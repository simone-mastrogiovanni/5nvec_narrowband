function y=prp_buf(N,bias,ord)
% PRP_BUF  basic uniform fanction
%
%    y=prp_buf(N,ord)
%
%  N     number of data
%  ord   order

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random
y=(rand(N,ord)+bias)./(rand(N,ord)+bias);
y=prod(y,2);