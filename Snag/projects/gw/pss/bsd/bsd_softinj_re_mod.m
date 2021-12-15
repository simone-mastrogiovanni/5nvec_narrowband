function [out Hp Hc]=bsd_softinj_re_mod(in,sour,A)
% Software injection by reverse of bsd_dopp_sd (to be preferred to bsd_softinj)
%
%    out=bsd_softinj_re(in,sour,A)
% 
%   in     input bsd
%   sour   source structure
%   A      amplitude

% Snag Version 2.0 - February 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni, S. Frasca, C.Palomba - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.09053083288; % at epoch2000

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

%ph0=(0:N-1)*dt*2*pi*(f0-inifr);
obs=check_nonzero(in,1);
ph0=mod((0:N-1)*dt*(f0-inifr),1)*2*pi;
in=edit_gd(in,'y',exp(1j*ph0).*obs');

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
%fprintf('No Einstein delay!\n');

sig0=y_gd(out);
sig=sig0*0;

% 5-vect

nsid=10000;
stsub=gmst(t0)+dt*(0:N-1)*(86400/Tsid)/3600; % running Greenwich mean sidereal time 
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed

[~, ~ , ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
gl0=sid1(isub).*sig0.';
gl45=sid2(isub).*sig0.';
Hp=sqrt(1/(1+sour.eta^2))*(cos(2*sour.psi/180*pi)-1j*sour.eta*sin(2*sour.psi/180*pi)); % estimated + complex amplitude (Eq.2 of ref.1)
Hc=sqrt(1/(1+sour.eta^2))*(sin(2*sour.psi/180*pi)+1j*sour.eta*cos(2*sour.psi/180*pi));
sig=Hp*gl0+Hc*gl45;

sig=sig.';

out=edit_gd(out,'y',A*sig+y);
out=bsd_zeroholes(out);