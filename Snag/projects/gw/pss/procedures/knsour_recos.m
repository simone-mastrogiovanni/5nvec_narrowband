% knsour_recos

% sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist1.txt','vela_vsr1_A.sbl');
% 
% ga=pss_band_recos(vela(),'vela_vsr1_A.sbl',1024);
% 
% velaA_sel=re_apply_null(ga,'velaA\velaA_gd_null_20090304_155222.txt')
% 
% [velaA_clip ssigmf_A]=ada_clip_c(velaA_sel,10,1000,5,0);
% 
% [gwA noisA ecqA tecqA wienA]=ps_wiener(velaA_sel,5);
% 
% save('velaA','ga','velaA_sel','velaA_clip','ssigmf_A','gwA','noisA','ecqA','tecqA','wienA')
% 
% 
% sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist2.txt','vela_vsr1_B.sbl');
% 
% gb=pss_band_recos(vela(),'vela_vsr1_B.sbl',1024);
% 
% velaB_sel=re_apply_null(gb,'velaB\velaB_gd_null_20090305_125610.txt')
% 
% [velaB_clip ssigmf_B]=ada_clip_c(velaB_sel,10,1000,5,0);
% 
% [gwB noisB ecqB tecqB wienB]=ps_wiener(velaB_sel,5);
% 
% save('velaB','gb','velaB_sel','velaB_clip','ssigmf_B','gwB','noisB','ecqB','tecqB','wienB')