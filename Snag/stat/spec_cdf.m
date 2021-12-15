function y=spec_cdf(x,sig)
% signal+noise normalized spectral pdf
%
%
%
%   x    spectral amplitude
%   sig  signal linear amplitude

% Snag Version 2.0 - February 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=ncx2cdf(2*x,2,2*sig^2);