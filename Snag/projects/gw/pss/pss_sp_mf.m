function gout=pss_sp_mf(gin,filt,fsid)
%PSS_SP_MF  spectral matched filter
%
%      filt   5-array with the coefficients of the filters for the
%             different sidereal lines (1->5 == -2 -1 0 1 2)
%      fsid   sidereal frequency (in gin dx units)
%

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

y=y_gd(gin);
dx=dx_gd(gin);
n=n_gd(gin);
capt=capt_gd(gin);

dom=2*pi/(dx*n);
n2=floor(n/2);
n3=n-n2+2;
w=zeros(1,n);
w(1:n2+1)=exp(i*dom*fsid*(0:(n2)));
w(n:-1:n3)=conj(w(2:n2));

mf=filt(3)+filt(1)./w.^2+filt(2)./w+filt(4).*w+filt(5).*w.^2;

y=fft(y);
y=y.*mf';
y=ifft(y);
y=real(y);

gout=edit_gd(gout,'y',y,'capt',[capt ' filtered']);