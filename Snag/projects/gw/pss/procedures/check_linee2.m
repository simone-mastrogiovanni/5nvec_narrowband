% check_linee2

fr=108.8571594;
fr1=108.75;
fr2=108.95;
ifr=floor(fr);
sblfile1=['d_' num2str(ifr)];
sblfile=[sblfile1 'vsr2_noveto.sbl'];

sfdb09_band2sbl([fr1 fr2],2,'','O:\pss\virgo\sfdb\VSR2\D_4096\list.txt',sblfile);

eval([sblfile1 '=pss_band_recos(0,''' sblfile ''',1024);'])

eval(['s_' sblfile1 '=gd_pows(' sblfile1 ',''pieces'',1,''resolution'',4,''window'',2)'])
eval(['s=edit_gd(s_' sblfile1 ',''ini'',ini_gd(s_' sblfile1 ')-' num2str(fr-ifr) ')'])
eval(['figure,semilogy(s)']),grid on
eval(['w_' sblfile1 '=gd_worm(' sblfile1 ',''freq'',' num2str(fr) ')'])
eval(['figure,plot(y_gd(w_' sblfile1 ')),hold on,plot(y_gd(w_' sblfile1 '),''r.'')']),grid on