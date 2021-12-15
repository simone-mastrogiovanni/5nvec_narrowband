function [sid,out_nc,bsd_ftr,hol,v,tculm]=bsd_funblock_noncohe_frsd(target,freq1,bsd_out,sd1,sd2)
% bsd_funblock_noncohe_frsd
%
% non-coherent procedure to find fr and sd
%   needs procedure bsd_block_1
%   needs data sd1 and sd2
%
% sd1=-1.e-12;
% sd2=0.3e-12;

SD=86164.09053083288;
FS=1/SD;
Dfr=(-2:2)*FS;
xs=target.f0+Dfr;
[out_nc,bsd_ftr]=bsd_find_fr_sd(bsd_out,target,freq1,[sd1 sd2])
f5v=out_nc.f5v;
fprintf('Theoretical frequency %.7f Hz  found %.7f Hz  diff %d \n',xs(3),f5v.frs5v(3),f5v.frs5v(3)-xs(3))

plot_lines(xs,f5v.fil)

% [v,tculm]=bsd_5vec(bsd_ftr,xs(3));

hol=bsd_hole_window(bsd_ftr,1);

sid=bsd_sid(bsd_ftr,target,100)

[v,tculm]=bsd_5vec(bsd_ftr,f5v.frs5v(3));