function y=prp_bef(N,bias,ord)
% PRP_BUF  basic exponential fanction
%
%    y=prp_bef(N,bias,ord)
%
%  N     number of data
%  bias  distortion bias
%  ord   order

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random
y=((rand(N,ord)+bias).^2+rand(N,ord).^2)./((rand(N,ord)+bias).^2+rand(N,ord).^2);
y=prod(y,2);