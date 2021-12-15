function [vel pos ein tout]=dop_ant(ant,tim,doptabs)
% vel,pos,einst for some time samples
%
%   ant      antenna structure or name
%   tim      [start (mjd) samp.t (s) n] or all the times (> 3)
%   doptabs  doptabs structure (a field each antenna, 
%            columns are (mjd posx posy posz velx vely velz einst)
%
%  velocity, position normalized in c
%  einstein effect: Doppler effect= Doppler - source_freq*deinstein

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isstruct(ant)
    ant=ant.name;
end

if isfield(doptabs,ant)
    eval(['tab=doptabs.' ant ';']) 
else
    sprintf(' *** %s antenna not present in tables \n',ant)
    return
end

timini=tim(1);

if length(tim) == 3
    n=tim(3);
    timfin=tim(1)+tim(2)*tim(3)/86400;
    tout=(0:n-1)*tim(2)/86400;
else
    n=length(tim);
    timfin=tim(n);
    tout=tim-timini;
end

[i2 dum]=size(tab);

ii=find(tab(:,1) >= timini & tab(:,1) <= timfin);

ii1=max(1,ii(1)-1);
ii2=min(i2,ii(length(ii))+1);
tab=tab(ii1:ii2,:);
tin=tab(:,1)-tim(1);

vel=zeros(n,3);
pos=vel;
ein=zeros(n,1);

for k = 1:3
    vel(:,k)=spline(tin,tab(:,4+k),tout);
end

for k = 1:3
    pos(:,k)=spline(tin,tab(:,1+k),tout);
end

ein(:)=spline(tin,tab(:,8),tout);

tout=tout+tim(1);