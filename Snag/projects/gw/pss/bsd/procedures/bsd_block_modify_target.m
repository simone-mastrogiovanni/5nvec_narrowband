% bsd_block_modify_target
%
% simply modification of target
%
% bsd_block procedures: copy the script in the work folder
%  with different name and modify
% do not modify original block

% target.name=
target.a=target.a+0.001*(rand(1,1)-0.5);
target.d=target.d+0.001*(rand(1,1)-0.5);
% target.f0=
% target.df0=
% target.ddf0=
% target.eta=
% target.psi=
% target.hname=

[l,b]=astro_coord('equ','ecl',target.a,target.d);
target.ecl=[l,b];