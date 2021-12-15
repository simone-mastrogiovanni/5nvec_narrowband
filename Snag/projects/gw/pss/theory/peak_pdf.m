function y=peak_pdf(sig,x)
%PEAK_PDF   distribution of spectral peaks
%
%    sig    signal spectral amplitude
%     x     peak amplitude
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

c1=2/3;
y1=2*ncx2pdf(2*x,2,2*sig);
y=y1.*((1-exp(-x)).^2)./(1-c1.^(1+sig));

