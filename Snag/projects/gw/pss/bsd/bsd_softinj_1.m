function [sbsd,out_si]=bsd_softinj_1(gin,sour,A)
% bsd software injection (prefere bsd_softinj_ie)
%
%    sbsd=bsd_softinj(gin,sour,A)
%
%   gin    input bsd (or bsd data structure)
%   sour   source
%   A      amplitude (if not present, use sour h)

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio, O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.090530833; % at epoch2000
% Tsidfact=Tsid/86400;
% outsid=inisid+(n*dt/Tsid)*24;
frsid=1/Tsid;
inisid1=0;

if ~exist('A','var')
    A=sour.h;
end

if isstruct(gin)
    dt=gin.dt;
    n=gin.n;
    t0=gin.t0;
    inifr=gin.inifr;
    bandw=gin.bandw;
    ant1=gin.ant;
    icstr=1;
else
    dt=dx_gd(gin);
    n=n_gd(gin);
    cont=ccont_gd(gin);
    t0=cont.t0;
    inifr=cont.inifr;
    bandw=cont.bandw;
    ant1=cont.ant;
    icstr=0;

    oper=struct();
    oper.op='bsd_softinj';
    if isfield(cont,'oper')
        oper.oper=cont.oper;
    end
    oper.sour=sour;
    oper.A=A;

    cont.oper=oper;
end

eval(['ant=' ant1 ';'])

sour=new_posfr(sour,t0);
f0=sour.f0;
f00=f0(1);
bin=0;
if isfield(sour,'bin')
    bin=sour.bin;
end

% detector doppler data

if icstr == 0
    VPstr=extr_velpos_gd(gin);
    [~,vs]=interp_VP(VPstr,sour);
else
    vel=dop_ant(ant,[t0 dt n],doptabs);

    r=astro2rect([sour.a sour.d],0);
    r=repmat(r,n,1);
    % f0=sour.f0;

    vs=dot(vel,r,2); 
end

out_si.vs=vs;

% naked frequency

gpar=[dt n];

if length(f0) > 1
    sdpar=f0(2:length(f0));
else
    sdpar(1)=sour.df0;
    sdpar(2)=0;
    if isfield(sour,'ddf0')
        sdpar(2)=sour.ddf0;
    end
    f0(2:3)=sdpar;
end

% fr=vfs_spindown(gpar,sdpar*1.00004,1)+f00+0.000003;
fr=vfs_spindown(gpar,sdpar,1)+f00;
out_si.sd=fr-f00;

% binary effect

if isfield(sour,'bin') 
end

% detector doppler

fr=fr.*(1+vs');
out_si.fr=fr;

% signal

sig=cumsum(fr)*dt*2*pi;
sig0=exp(1j*sig);
out_si.sig0=sig0;
sig=sig*0;

% 5-vect

[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant);

for k = -2:2
    bb=(frsid*k)*2*pi*((0:n-1)*dt+inisid1);
    aa=exp(1j*bb);
    sig=sig+v(k+3)*aa.*sig0;
end

sig=A*sig;

if icstr == 1
    sbsd=gd(sig);
    sbsd=edit_gd(sbsd,'dx',dt);
else
    sbsd=edit_gd(gin,'y',sig);
end
