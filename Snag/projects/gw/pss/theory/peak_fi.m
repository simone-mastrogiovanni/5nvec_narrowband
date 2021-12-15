function y=peak_fi(sig,xmax,dx)
%PEAK_fi   peaks Fi-function (basic part of the CR_hm)
%
%    sig    signal spectral amplitude
%    xmax   max peak amplitude (a value at which the cdf is about 1)
%    dx     resolution  
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

x=peak_prob(sig,xmax,dx);
x0=peak_prob(0,xmax,dx);

y=(x-x0)./sqrt(x0.*(1-x0));
