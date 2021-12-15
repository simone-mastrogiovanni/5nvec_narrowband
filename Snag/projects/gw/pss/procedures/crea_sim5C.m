% crea_sim5C

ant=virgo;

sour=vela;
sour.eps=1;
sour.psi=0;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\velaC.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_linpol0.sbl')

sour=vela;
sour.eps=1;
sour.psi=45;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\velaC.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_linpol45.sbl')

sour=vela;
sour.eps=0;
sour.psi=-20;
ant=virgo;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\velaC.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_circpolC.sbl')

sour=vela;
sour.eps=0;
sour.psi=20;
ant=virgo;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\velaC.txt','sim5.sbl',{sour ant 1});
fclose('all')
system('rename sim5.sbl sim5L_circpolA.sbl')

pL0=pss_band_recos(vela(),'sim5L_linpol0.sbl',1024);
pL45=pss_band_recos(vela(),'sim5L_linpol45.sbl',1024);
pCA=pss_band_recos(vela(),'sim5L_circpolA.sbl',1024);
pCC=pss_band_recos(vela(),'sim5L_circpolC.sbl',1024);

save('SimVelaC','pL0','pL45','pCA','pCC')