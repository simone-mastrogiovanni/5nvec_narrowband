function sig=signal_5vec_bsd(bsd,v5,tculm,fr0)
% compute bsd signal from 5vect and frequency
%
%   bsd    input bsd (only for auxiliary info)
%   v5     5-vector
%   fr0    carrier frequency

% Snag Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

FS=1/86164.09053083288;
Dfr=(-2:2)*FS;

cont=ccont_gd(bsd);
t0=cont.t0;
dt=dx_gd(bsd);
N=n_gd(bsd);

t=(0:N-1)*dt+(t0-tculm)*86400;
sig=t*0;

fr=fr0+Dfr;

for k = 1:5
    bb=fr(k)*2*pi*t;
    aa=exp(1j*bb);
    sig=sig+v5(k)*aa;
end

sig=gd(sig);
cont.t0=t0;
cont.fr0=fr0;
% cont.fr_noal=fr_noal;
bandw=1/dt;
inifr=floor(fr0/bandw)*bandw;
cont.inifr=inifr;
cont.bandw=bandw;
sig=edit_gd(sig,'dx',dt,'cont',cont);