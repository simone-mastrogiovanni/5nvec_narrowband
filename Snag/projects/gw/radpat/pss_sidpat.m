function [sidpat,ftsp,v]=pss_sidpat(sour,ant,n,culm)
% sidereal power pattern (Greenwich Sidereal Time)
%
%     radpat=pss_sidpat(source,antenna,n)
%
%  sour,ant   source and antenna structures
%  n          number of points in the sidereal day (def 240)
%  culm       =1 culmination 5-vect (or basic 5-vect; def 0) 

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('n','var')
    n=240;
end
if ~exist('culm','var')
    culm=0;
end

[L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant,culm);

st=(0:n-1)*2*pi/n;

lf=0;
for i = 1:5
    lf=lf+v(i)*exp(1j*(i-3)*st);
end

sidpat=abs(lf).^2;
ftsp=fft(sidpat);
fnorm=sqrt(sum(abs(ftsp).^2));
ftsp=ftsp/fnorm;
sidpat=gd(sidpat);
sidpat=edit_gd(sidpat,'dx',24/n);