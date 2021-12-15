function [fout,aout]=pss_rough_simpeak(bias,lfft,nmax,thresh,constlin,v,ant,sour)
% PSS_ROUGH_SIMPEAK  creates a peak vector with the bin freq range in
%                    bias+lfft/2 and exponential amplitude 
%
%    [fout,aout]=pss_rough_simpeak(bias,lfft,nmax,thresh,constlin,v,tsid,ant,sour)
%
%     bias          lower freq bin value (-1; typically 0)
%     lfft          fft length (or 2*{band in bins})
%     nmax          number of peaks (if = 0, use thresh)
%     thresh        threshold (used if nmax=0)
%     conslin(2,n)  vector with constant freq and amplitude
%     v(3)          velocity of thedetector (in units of c, in equatorial-cartesian)
%     tsid          sidereal time
%     ant           antenna structure
%     sour          sources structure array

% Version 2.0 - March 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

lfft2=lfft/2;

if nmax > 0
    bb=round(rand(nmax,1)*lfft/2);
    bb=sort(bb);
else
    y=(randn(lfft2,1).^2+randn(lfft2,1).^2)/2;
    
    y1=rota(y,1);
    y2=rota(y,-1);
    y1=ceil(sign(y-y1)/2);
    y2=ceil(sign(y-y2)/2+0.1);
    y1=y1.*y2;
    y=y.*y1;
    y2=ceil(sign(y-thresh)/2);
    y=y.*y2;
    npeak=sum(y2);
    [fout,j1,s1]=find(y);
end

fout=fout+bias;
aout=0;