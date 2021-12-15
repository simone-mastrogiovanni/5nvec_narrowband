function y=peak_cdf(sig,xmax,dx)
%PEAK_CDF   cumulative distribution of spectral peaks
%
%    sig    signal spectral amplitude
%    xmax   max peak amplitude
%    dx     resolution  
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

x=dx:dx:xmax;
c1=2/3;
y1=2*ncx2pdf(2*x,2,2*sig);
y1=y1.*((1-exp(-x)).^2)/(1-c1.^(1+sig));
y=cumsum(y1)*dx;

