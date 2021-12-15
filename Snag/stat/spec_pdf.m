function y=spec_pdf(x,sig)
% Psi function: linear Hough pdf without signal+noise normalized spectral pdf
%
%     y=hough_pdf(x,sig)
%
%   x    spectral amplitude
%   sig  signal linear amplitude

% Snag Version 2.0 - February 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=2*ncx2pdf(2*x,2,2*sig^2);