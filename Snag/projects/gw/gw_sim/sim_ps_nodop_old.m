function [gdps ft]=sim_ps_nodop_old(sour,ant,t0,dt,N,ph0)
%SIM_PS_NODOP  periodic source simulation without Doppler effect
%
%   [gdps ft]=sim_ps_nodop(sour,ant,t0,dt,N,ph0)
%
%  computes ft only if df0=0
%
%  sour,ant   source and antenna structure
%  t0         initial time (mjd)
%  dt         sampling time (s)
%  N          number of samples
%  ph0        signal phase (deg)

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ph0','var')
    ph0=0;
end
source1=sour;
source1.eps=1;
source1.psi=0;
source2=sour;
source2.eps=1;
source2.psi=45;

nsid=10000;
dsid=24/nsid;
sid1=zeros(1,nsid);
sid2=sid1;
for i = 1:nsid
    tsid=i*dsid;
    sid1(i)=lin_radpat_interf(source1,ant,tsid);
    sid2(i)=lin_radpat_interf(source2,ant,tsid);
end
eps=sour.eps;
psi=sour.psi*pi/180;
fi=2*psi;
rot=1;
if psi < 0
    rot=-1;
    psi=psi+90;
end

sour=new_posfr(sour,t0);
f0=sour.f0;
df0=sour.df0;
ddf0=sour.ddf0;

Dt0=0;

tt=Dt0+dt*(0:N-1);
ph=(f0*tt+df0*tt/2.^2+ddf0*tt.^3/6)*2*pi+ph0*pi/180;
% ph=mod(fr0*pos*2*pi+ph1,2*pi);
st=gmst(t0+tt/86400);
i1=mod(round(st*(nsid-1)/24),nsid-1)+1; 

xc=cos(ph+fi)*(1-eps)/sqrt(2); 
yc=sin(ph+fi)*(1-eps)/sqrt(2);
xl=cos(ph)*eps*cos(2*psi);
yl=cos(ph)*eps*sin(2*psi);
gdps=(sid1(i1).*(xc+xl)+rot*sid2(i1).*(yc+yl));

if df0 == 0
    fsid=1/86164.0905;
    e0=exp(1i*tt*f0*2*pi);
    e1=exp(1i*tt*fsid*2*pi);
    for i = -2:2
        ft(i+3)=sum(gdps.*e0.*(e1.^i))*dt/N;
    end
end

gdps=gd(gdps);
gdps=edit_gd(gdps,'dx',dt);  