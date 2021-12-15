% bsd_block_sidpat
%
% produces and analyze the sidereal pattern
%   needs bsd_ftr
%
% bsd_block procedures: copy the script in the work folder
%  with different name and modify
% do not modify original block

sid=bsd_sid(bsd_ftr,target,100);

sidpat_base=ana_sidpat_base(ant,target);
asp=ana_sidpat(sid.pow,sidpat_base)
[v,tculm,rv]=bsd_5vec(bsd_ftr,f5v.frs5v(3));