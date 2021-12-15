function y=trasfun_pz(fr,pol,npol,zer,nzer,amp)
%TRASFUN_PZ   computes the transfer function at the frequencies given by the vector fr,
%          given the poles pol, the zeros zer and amplitude amp
%
%    fr		frequencies vector
%    pol    poles vector
%    npol   number of poles
%    zer    zeros vector
%    nzer   number of zeros
%    amp    multiplicative constant

% Version 1.0 - April 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2001  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


y=(fr.*0+1)*amp;

for i=1:nzer
   y=y.*(j*2*pi*fr-zer(i));
end

for i=1:npol
   y=y./(j*2*pi*fr-pol(i));
end