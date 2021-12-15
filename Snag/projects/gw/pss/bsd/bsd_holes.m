function [zhole, shole, thole]=bsd_holes(in)
% identifies holes in a bsd
%
%   in     input bsd
%
%   holes  a vector with odd elements index of starting data and even elements index of starting hole
%   thole  (n 2) start and stop mjd of holes

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

minhole=2;

n=n_gd(in);
ii=sign(abs(y_gd(in)));
ii=[0; ii];
dii=diff(ii);
idii=find(dii ~= 0);
holes=[idii; n];
nh=length(holes)/2;

inihole=holes(2:2:nh*2);
inihole=[1; inihole];
finhole=holes(1:2:nh*2)-1;
if length(finhole) < length(inihole)
    finhole=[finhole; n]; % size(inihole),size(finhole)
end

dholes=finhole-inihole;
jj=find(dholes > minhole);
inihole=inihole(jj);
finhole=finhole(jj);

dt=dx_gd(in);
cont=ccont_gd(in);
t0=cont.t0;

zhole=[inihole,finhole];
shole=round((zhole-1)*dt,1);
thole=adds2mjd(t0,(zhole-1)*dt);