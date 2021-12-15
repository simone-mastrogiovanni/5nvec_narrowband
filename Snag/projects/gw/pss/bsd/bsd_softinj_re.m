function [out,v,L0,L45]=bsd_softinj_re(in,sour,A)
% Software injection by reverse of bsd_dopp_sd (to be preferred to bsd_softinj)
%
%    out=bsd_softinj_re(in,sour,A)
% 
%   in     input bsd
%   sour   source structure
%   A      amplitude

% Snag Version 2.0 - February 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.090530833; % at epoch2000

frsid=1/Tsid;
inisid1=0;

N=n_gd(in);
dt=dx_gd(in);
cont=cont_gd(in);
y=y_gd(in);
t0=cont.t0;
inifr=cont.inifr;
ant1=cont.ant;
eval(['ant=' ant1 ';'])

sour=new_posfr(sour,t0);
fr=[sour.f0,sour.df0,sour.ddf0];
f0=sour.f0;
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

ph0=(0:N-1)*dt*2*pi*(f0-inifr);
in=edit_gd(in,'y',exp(1j*ph0));

VPstr=extr_velpos_gd(in);
pO=interp_VP(VPstr,sour);
out=vfs_subhet_pos(in,fr,-pO);

if sum(abs(sdpar)) > 0
    gdpar=[dt,N];

    sd=vfs_spindown(gdpar,sdpar,1);

    out=vfs_subhet(out,-sd);
end

einst=einst_effect(t0:dt/86400:t0+(N-0.5)*dt/86400);

out=vfs_subhet(out,(einst-1)*fr(1));

sig0=y_gd(out);
sig=sig0*0;

% 5-vect

[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant);

for k = -2:2
    bb=(frsid*k)*2*pi*((0:N-1)*dt+inisid1);
    aa=exp(1j*bb);
    sig=sig+v(k+3)*aa.'.*sig0;
end

out=edit_gd(out,'y',A*sig+y);

out=bsd_zeroholes(out);