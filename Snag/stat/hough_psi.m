function [psi,snr,psi1]=hough_psi(thr,snr)
% Psi function (for linear Hough) 
%
%     [psi,snr,psi1]=hough_psi(thr,snr)
%
%   thr  spectral threshold
%   snr  spectrum signal linear amplitude

% Snag Version 2.0 - March 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y0=specpeak_prob(thr,0);

n=length(snr);
psi=zeros(1,n);
psi1=psi;

for i = 1:n
    sn=snr(i);
    y=specpeak_prob(thr,sn);
    psi(i)=sqrt((y-y0)./sqrt(y0.*(1-y0)));
    psi1(i)=sqrt(y./sqrt(y0.*(1-y0)));
end