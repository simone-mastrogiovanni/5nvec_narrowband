function out=bsd_cohe(in,target,par)
% bsd coherent detection
%
%    in      extracted band bsd
%    target  target source
%    par     mode structure with parameters (def mod=0)
%            = 0  full knowledge

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

global bsd_glob_noplot
if ~exist('par','var')
    mod=0;
end

if bsd_glob_noplot
    icplot=0;
else
    icplot=1;
end

cont=cont_gd(in);
eval(['ant=' cont.ant ';'])

[L0 L45 CL CR vt Hp Hc]=sour_ant_2_5vec(target,ant,1);
out.vt=vt;

out.bsd_corr=bsd_dopp_sd(in,target);

switch mod
    case 0
        [vs,tculm,rv]=bsd_5vec(out.bsd_corr,target.f0,target.a);
        out.vs=vs;

        out.comp=compare_5vec(vt,vs,icplot);
end