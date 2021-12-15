% bsd_block_sid_ana
%
% sidereal analysis
%   needs procedure bsd_block_1
%   produces bsd_out,BSD_tab_out,stpar
%
% bsd_block procedures: copy the script in the work folder
%  with different name and modify
% do not modify original block

enl=10;
frdec=target.f0;
frs=[frdec-5.1/SD,frdec+5.1/SD];

[bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,target);

[bsd_ftr,out]=bsd_ftrim(bsd_corr,frs,enl,1);

sid=bsd_sid(bsd_ftr,target,100)