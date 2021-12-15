function sp=sidpat_by_harms(sidpat,n)
% computes the clean sidereal pattern from an experimental s.p. or just harmonics
%
%   sidpat   sidereal pattern or 5 harmonics 
%   n        length of output sidpat (def the input dimension)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

lsp=length(sidpat);
if lsp > 5
    sumin=sum(sidpat);
    fsidpat=fft(sidpat);
    sph=fsidpat(1:5);
    if ~exist('n','var')
        n=lsp;
    end
else
    sph=sidpat;
end

sp=zeros(n,1);
sp(1:5)=sph;
sp(n:-1:n-3)=conj(sph(2:5));
sp=ifft(sp);
sumout=sum(sp);
if lsp > 5
    sp=sp*(sumin/sumout)*(n/lsp);
    d0=24/lsp;
    d1=24/n;
    figure,plot((0:lsp-1)*d0,sidpat),grid on
    hold on,plot((0:n-1)*d1,sp)
else
    d1=24/n;
    figure,plot((0:n-1)*d1,sp),grid on
end