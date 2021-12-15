function A=snr2A(snr,Nfft,thr)
% Hough peak from snr
%
%   snr    linear SNR
%   Nfft   number of FFTs
%   thr    threshold
%
%    A=snr2A(snr,Nfft,thr)

% Snag Version 2.0 - February 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

n=length(snr);
lam=snr.^2;
pot=zeros(1,n);
dx=0.1;

for i = 1:n
    pot(i)=peak_pot_1(lam(i),thr,dx);
end

A=Nfft*pot;