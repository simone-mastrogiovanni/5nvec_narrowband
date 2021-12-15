% riprova_21_mag

ant=virgo;

sour=vela;
sour.eps=1;
sour.psi=0;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist2.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_linpol0.sbl')

sour=vela;
sour.eps=1;
sour.psi=45;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist2.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_linpol45.sbl')

sour=vela;
sour.eps=0;
sour.psi=-20;
ant=virgo;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist2.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_circpolC.sbl')

sour=vela;
sour.eps=0;
sour.psi=20;
ant=virgo;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\pialist2.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_circpolA.sbl')


pL0=pss_band_recos(vela(),'sim5L_linpol0.sbl',1024);
pL45=pss_band_recos(vela(),'sim5L_linpol45.sbl',1024);
pCA=pss_band_recos(vela(),'sim5L_circpolA.sbl',1024);
pCC=pss_band_recos(vela(),'sim5L_circpolC.sbl',1024);

save('SimVela','pL0','pL45','pCA','pCC')

pL0sel=re_apply_null(pL0,'C:\Users\Sergio Frasca\Documents\MATLAB\velaB\velaB_gd_null_20090305_125610.txt')
pL45sel=re_apply_null(pL45,'C:\Users\Sergio Frasca\Documents\MATLAB\velaB\velaB_gd_null_20090305_125610.txt')
pCAsel=re_apply_null(pCA,'C:\Users\Sergio Frasca\Documents\MATLAB\velaB\velaB_gd_null_20090305_125610.txt')
pCCsel=re_apply_null(pCC,'C:\Users\Sergio Frasca\Documents\MATLAB\velaB\velaB_gd_null_20090305_125610.txt')

save('SimVelaSel','pL0sel','pL45sel','pCAsel','pCCsel')