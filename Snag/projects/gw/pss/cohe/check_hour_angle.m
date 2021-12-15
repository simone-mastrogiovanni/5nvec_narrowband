function [cohe sour stat]=check_hour_angle(dat_5,l0_5,l45_5,n)
% CHECK_HOUR_ANGLE  checks coherence for changing hour angle
%
%       [cohe sour stat]=check_hour_angle(dat5,l0_5,l45_5,n)
%
%    dat_5        data 5-vec or gd
%    l0_5,l45_5   lin pol 5-vecs or gds
%    n            number of points (def 360)

% Version 2.0 - March 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('n','var')
    n=360;
end

dha=2*pi/n;

if isobject(dat_5)
    cont=cont_gd(dat_5);
    fr0=cont.appf0;
    dat_5=compute_5comp(dat_5,fr0);
end
if isobject(l0_5)
    cont=cont_gd(l0_5);
    fr0=cont.appf0;
    l0_5=compute_5comp(l0_5,fr0);
end
if isobject(l45_5)
    cont=cont_gd(l45_5);
    fr0=cont.appf0;
    l45_5=compute_5comp(l45_5,fr0);
end

for i = 1:n
    ha=mod((i-1)*dha-pi,2*pi);
    HA=exp(-1j*(-2:2)*ha);
    L0=l0_5.*HA;
    L45=l45_5.*HA;
    [sour stat]=estimate_psour(dat_5,L0,L45);
    cohe(i)=stat.cohe(3);
end

[c I]=max(cohe);

ha=mod((I-1)*dha-pi,2*pi);
HA=exp(-1j*(-2:2)*ha);
L0=l0_5.*HA;
L45=l45_5.*HA;
[sour stat]=estimate_psour(dat_5,L0,L45);