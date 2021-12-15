function out=disc_fourier(in,Om)
%DISC_FOURIER  no FFT Fourier transform
%
%   in   input data 
%   Om   Omega (normalize ang freq) values

% Version 2.0 - August 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

m=length(Om);
n=length(in);
ii=0:n-1;
out=Om*0;

for i = 1:m
    e=exp(-j*Om(i));
    out(i)=sum(in.*(e.^ii));
end