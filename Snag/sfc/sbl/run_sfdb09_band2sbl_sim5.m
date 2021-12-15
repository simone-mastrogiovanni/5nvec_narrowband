% run_sfdb09_band2sbl_sim5

sour=vela;
sour.eps=0;
ant=virgo;

sfdb09_band2sbl([22.25 22.5],2,'','O:\pss\virgo\sfdb\VSR1-v2\list.txt','sim5.sbl',{sour ant 1});
