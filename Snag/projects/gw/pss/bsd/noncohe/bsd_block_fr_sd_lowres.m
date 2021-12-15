% bsd_block_fr_sd_lowres
%
% low-resolution non-coherent procedure to find fr and sd
%   needs procedure bsd_block_1
%   needs data npiece, SDband, sd1 and sd2
%       par       search parameters (there is a default)
%        .nl    raw search reduction factor (def 5)
%        .nh    refined search enhancement factor (def 2)
%        .refb  refinement band (in natural units, def 5)
%        .enl   enlargement factor for bsd_trim
%   produces bsd_out,BSD_tab_out,stpar
%
% bsd_block procedures: copy the script in the work folder
%  with different name and modify
% do not modify original block

npiece=10;
SDband=5.1;
sd1=-1.e-11;
sd2=1.e-11;
sds=[sd1,sd2];
frdec=target.f0;
frs=[frdec-SDband/SD,frdec+SDband/SD];

% [out,bsd_ftr]=bsd_find_fr_sd_lowres(bsd_out,npiece,target,frs,sds,par)
[out,bsd_ftr]=bsd_find_fr_sd_lowres(bsd_out,npiece,target,frs,sds) % default par