function y=spec_rcdf(sig,xmax,dx)
%SPEC_RCDF   reverse cumulative distribution of spectral amplitudes
%
%    sig    signal spectral amplitude
%    xmax   max peak amplitude (a value at which the cdf is about 1)
%    dx     resolution  
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

x=dx:dx:xmax;
n=length(x);
x=dx:dx:(xmax*1.2);
c1=2/3;
y1=2*ncx2pdf(2*x,2,2*sig);
y1=cumsum(y1(length(y1):-1:1))*dx;
y1=y1(length(y1):-1:1);
y=y1(1:n)/y1(1);

