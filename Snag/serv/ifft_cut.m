function x=ifft_cut(X,n)
% inverse fft with cut to be used with fft(x,N)
%
%   X    input transformed array (dim N created by fft(x,N), x dim being n)
%   n    cut the first n values

% Snag Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

x=ifft(X);
x=x(1:n);