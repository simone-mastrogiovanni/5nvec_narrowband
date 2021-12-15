function [h0 eta psi cohe]=simp_estimate_psour(dat_5,L0,L45)
% SIMP_ESTIMATE_SOUR estimate of periodic source parameters
%
%      [sour stat matfil]=estimate_psour(dat_5,L0,L45)
%
%   dat_5    5-vect with data (obtained e.g. by compute_5comp)
%   L0,L45   5-vects with signals

% Version 2.0 - April 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

mf0=conj(L0)./norm(L0).^2;
mf45=conj(L45)./norm(L45).^2;

hp=sum(dat_5.*mf0);
hc=sum(dat_5.*mf45);
sig=hp*L0+hc*L45;
[mf cohe]=mfcohe_5vec(dat_5,sig);

h0=sqrt(norm(hp)^2+norm(hc)^2);

a=hp/h0;
b=hc/h0;

A=real(a*conj(b));
B=imag(a*conj(b));
C=norm(a)^2-norm(b)^2;

eta=(-1+sqrt(1-4*B^2))/(2*B);
cos4psi=C/sqrt((2*A)^2+C^2);
sin4psi=2*A/sqrt((2*A)^2+C^2);
psi=(atan2(sin4psi,cos4psi)/4)*180/pi;
