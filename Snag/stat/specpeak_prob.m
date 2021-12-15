function p=specpeak_prob(thr,snr)
% spectral peak probability
%
%       p=specpeak_prob(thr,snr)
%
%   thr    threshold
%   snr    normalized signal
%
%   Needs the Statistical toolbox

% Snag Version 2.0 - February 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

xmax=(7+2*snr^2)*1.2;
dx=0.01;
x=thr:dx:xmax;

y=spec_pdf(x,snr).*((1-exp(-x)).^2);

p=sum(y)*dx;