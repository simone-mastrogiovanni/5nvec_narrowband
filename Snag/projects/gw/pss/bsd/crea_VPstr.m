function [VPstr,contout]=crea_VPstr(ant,timdop,doptabs,ingd)
% vel,pos,einst for some time samples
%
%   ant      antenna structure or name
%   timdop   times for doppler data [start (mjd) samp.t (s) n] ! def values for 0
%   doptabs  doptabs structure (a field each antenna, 
%            columns are (mjd posx posy posz velx vely velz einst)
%   ingd     imperfect gd or reuested
%
%  VPstr used in interp_VP and other bsd software

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

dt=0.1;
DT=1024;
icgd=0;
n=0;
if exist('ingd','var')
    cont=cont_gd(ingd);
    t0=cont.t0;
    DT=cont.Tfft/2;
    dt=dx_gd(ingd);
    n=n_gd(ingd);
    icgd=1;
end

if timdop(2) > 0
    DT=timdop(2);
end
if timdop(1) > 0
    t0=timdop(1)-DT/86400;
end
if timdop(3) > 0
    ndop=timdop(3);
else
    ndop=floor(n*2*dt/cont.Tfft);
end

timdop=[t0 DT ndop];

[vel pos ein tout]=dop_ant(ant,timdop,doptabs);

VPstr.VP=zeros(ndop,8);

VPstr.VP(:,2:4)=vel;
VPstr.VP(:,5:7)=pos;
t0gps=mjd2gps(t0);

VPstr.VP(:,1)=t0+(0:ndop-1)*DT/86400;
VPstr.VP(:,8)=(1:ndop)*DT;

VPstr.t0=t0;
VPstr.t0gps=t0gps;
VPstr.dt=dt;
VPstr.n=n;

if icgd > 0
    cont=cont_gd(ingd);
    contout=cont;
end
vel(:,4)=(1:ndop)*DT;
contout.v_eq=vel;
pos(:,4)=(1:ndop)*DT;
contout.p_eq=pos;