% crea_sim5

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
