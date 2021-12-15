function out=bsd_dopp_sd_noeist(in,sour,sdpar)
% Doppler and spin-down correction
%
%    out=bsd_dopp_sd(in,sour,sdpar)
% 
%   in     input bsd
%   sour   source structure
%   sdpar  spin-down parameters, if different from source
%           [df ddf] or df; if sd=0, no spin-down correction
%           if absent, uses sour parameters

% Snag Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=cont_gd(in);
t0=cont.t0;
if ~isfield(sour,'f0')
    sour.f0=100;
    sour.df0=0;
    sour.ddf0=0;
    sour.v_a=0;
    sour.v_d=0;
    sour.fepoch=t0;
    sour.pepoch=t0;
end
sour=new_posfr(sour,t0);
fr=[sour.f0,sour.df0,sour.ddf0];
if exist('sdpar','var')
    if length(sdpar) == 1
        sdpar(2)=0;
    end
    fr(2)=sdpar(1);
    fr(3)=sdpar(2);
else
    sdpar(1)=fr(2);
    sdpar(2)=fr(3);
end

VPstr=extr_velpos_gd(in);
pO=interp_VP(VPstr,sour);
out=vfs_subhet_pos(in,fr,pO);

if sum(abs(sdpar)) > 0
    N=n_gd(in);
    dt=dx_gd(in);
    gdpar=[dt,N];

    sd=vfs_spindown(gdpar,sdpar,1);

    out=vfs_subhet(out,sd);
end

oper=struct();
oper.op='bsd_dopp_sd';
if isfield(cont,'oper')
    oper.oper=cont.oper;
end
oper.sour=sour;
oper.sdpar=sdpar;

cont.oper=oper;

out=edit_gd(out,'cont',cont);