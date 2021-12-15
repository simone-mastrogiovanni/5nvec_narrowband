function y=spec_pdf(sig,x)
%SPEC_PDF   density of spectral values
%
%    sig    signal spectral amplitude
%     x     peak amplitude
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

y=2*ncx2pdf(2*x,2,2*sig);

