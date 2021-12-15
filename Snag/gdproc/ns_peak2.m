function [peaks,out,smooth]=ns_peak2(in,perc,thresh)
%NS_PEAK  non-stationary peak finder
%
%   in      input data gd
%   perc    percentage for low-pass
%   thresh  threshold
%
%   peaks   (sparse array)
%   out     normalized output

% Version 2.0 - March 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

out=in;

in=y_gd(in);
in1=fft(in);

n=length(in);
n1=ceil(perc*n/2);n,n1
in1(n1:n+2-n1)=0;
in1(1:n1-1)=in1(1:n1-1).*(n1-1:-1:1)'/(n1-1);
in1(n+2-n1+1:n)=in1(n+2-n1+1:n).*(1:n1-2)'/(n1-1);

smooth=ifft(in1);
in1=in./smooth;

out=edit_gd(out,'y',in1,'addcapt','destationarized data of');

peaks=1;