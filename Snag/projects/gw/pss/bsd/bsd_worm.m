function w=bsd_worm(bsd,freq,icshow)
% worm for bsd
%
%    bsd     bsd input
%    freq    frequency (not aliased)
%    icshow  = 1 plot

% Snag Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=ccont_gd(bsd);
freq=freq-cont.inifr;
w=gd_worm(bsd,'freq',freq,'icshow',icshow);