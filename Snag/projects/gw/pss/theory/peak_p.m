function y=peak_p(sig,x)
%PEAK_P   density of spectral peaks (not normalized)
%
%    sig    signal spectral amplitude
%     x     peak amplitude
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

y1=2*ncx2pdf(2*x,2,2*sig);
y=y1.*((1-exp(-x)).^2);

