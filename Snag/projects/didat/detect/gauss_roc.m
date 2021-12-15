function m=gauss_roc(nlin,maxsnr,minfa)
%GAUSS_ROC  computes the ROC (Receiver Operating Characteristic) diagram
%           in the linear gaussian case
%
%     nlin    number of lines
%     maxsnr  maximum snr
%     minfa   minimum false alarm

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N=300;
m=zeros(N,nlin);
rap=1/minfa;
rad=rap^(1/(N-1));
fa=minfa*rad.^(0:299);
thresh=invp_normextr(fa);% figure,plot(fa,thresh),figure,semilogx(fa,thresh)

for i = 1:nlin
    s=i*maxsnr/nlin;
    m(1:300,i)=1-normcdf(thresh-s);
end

figure
semilogx(fa,m),grid on

figure
plot(fa,m),grid on