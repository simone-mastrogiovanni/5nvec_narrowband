function out=check_inj(in,sour,ichole)
% Check injection
%
%   in      input bsd (not corrected)
%   sour    source or injection
%   ichole  > 0 insert input holes (def 1)

% Snag Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
if ~exist('ichole','var')
    ichole=1;
end
cont=ccont_gd(in);
t0=cont.t0;
eval(['ant=' cont.ant ';'])
% dt=dx_gd(in);
% n=n_gd(in);

sour=new_posfr(sour,t0);

in=bsd_dopp_sd(in,sour);

[v5,tculm]=bsd_5vec(in,sour.f0,sour.a);

out.v5=v5;

sig=signal_5vec_bsd(in,v5,tculm,sour.f0);
if ichole > 0
    sig=bsd_zeroholes(sig,in);
end

[~, ~, ~, ~, v5t, ~, ~]=sour_ant_2_5vec(sour,ant,1);
out.v5t=v5t;
out.tculm=tculm;

out.comp=compare_5vec(v5,v5t,1)

out.sig=sig;

MCF=crea_mc_filter(ant,sour,10000);
out.mcf=mc_filter(MCF,v5,1)

toc