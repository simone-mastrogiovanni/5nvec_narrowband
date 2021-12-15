function [out,knorm,gaus]=filt_renorm(filt,dat,fr0,w0)
% renormalization for bsd_frfilt
%
%  filt     filter creatrd by bsd_frfilt
%  dat      unfitered bsd
%  fr0      renormalization frequency
%  w0       pulse width

% Version 2.0 - October 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(dat);
n=n_gd(dat);
y=y_gd(dat);
cont=cont_gd(dat);

n2=floor(n/2);
t=((1:n)-n2)*dt;

gaus=exp(-t.^2/(4*w0^2)).*exp(1j*2*pi*fr0*t);

gaus1=bsd_resenh(gaus,10);

ampin=max(abs(gaus1));

Gaus=fft(gaus);

gout=ifft(Gaus.*filt');

gout1=bsd_resenh(gout,10);

ampout=max(abs(gout1));

knorm=ampout/ampin;

out=ifft(fft(y).* filt)*knorm;
out=gd(out);
out=edit_gd(out,'dx',dt,'cont',cont) 