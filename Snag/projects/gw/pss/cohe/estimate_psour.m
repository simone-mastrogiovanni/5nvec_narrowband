function [sour stat matfil]=estimate_psour(dat_5,L0,L45)
% ESTIMATE_SOUR estimate of periodic source parameters
%
%      [sour stat matfil]=estimate_psour(dat_5,L0,L45)
%
%   dat_5    5-vect with data (obtained e.g. by compute_5comp)
%   L0,L45   5-vects with signals
%
%   sour     structure with the parameters
%   stat     structure with the relevant statistics
%   matfil   matched filters

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

corr(1)=sum(L0.*conj(L45))/(norm(L0)*norm(L45));
corr(2)=sum(dat_5.*conj(L0))/(norm(dat_5)*norm(L0));
corr(3)=sum(dat_5.*conj(L45))/(norm(dat_5)*norm(L45));

mf0=conj(L0)./norm(L0).^2;
mf45=conj(L45)./norm(L45).^2;
matfil.mf0=mf0;
matfil.mf45=mf45;

hp=sum(dat_5.*mf0);
hc=sum(dat_5.*mf45);
sig=hp*L0+hc*L45;
cohe(1)=norm(mf0.*L0).^2/norm(dat_5).^2;
cohe(2)=norm(mf45.*L45).^2/norm(dat_5).^2;
[mf cohe(3)]=mfcohe_5vec(dat_5,sig)

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

sour.h0=h0;
sour.eta=eta;
sour.psi=psi;
sour.ahp=abs(hp);
sour.hp=hp;
sour.ahc=abs(hc);
sour.hc=hc;
sour.absphp=hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180)));
sour.absphc=hc/(h0*(sin(2*psi*pi/180)+1j*eta*cos(2*psi*pi/180)));
sour.absph=(sour.absphp+sour.absphc)/2;

stat.corr=corr;
stat.cohe=cohe;
cova(1)=norm(mf0.*L0).^2/norm(dat_5).^2;
cova(2)=norm(mf45.*L45).^2/norm(dat_5).^2;