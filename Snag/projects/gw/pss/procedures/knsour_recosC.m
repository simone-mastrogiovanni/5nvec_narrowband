% knsour_recosC

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\velaC.txt','vela_vsr1_C.sbl');

gC=pss_band_recos(vela(),'vela_vsr1_C.sbl',1024);

velaC_sel=re_apply_null(gC,'C:\Users\Sergio Frasca\Documents\MATLAB\velaC\gCsel_gd_null_20090605_151033.txt')

[velaC_clip ssigmf_C]=ada_clip_c(velaC_sel,10,1000,5,0);

[gwC noisC ecqC tecqC wienC]=ps_wiener(velaC_sel,5);

save('velaC','gC','velaC_sel','velaC_clip','ssigmf_C','gwC','noisC','ecqC','tecqC','wienC')