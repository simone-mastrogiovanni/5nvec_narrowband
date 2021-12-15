% check_lineeSim

fr=108.8571594;
ifr=floor(fr);

sblfile1=['sim_' num2str(ifr)];
sblfile='pulsar_3.sbl';

eval([sblfile1 '=pss_band_recos(0,''' sblfile ''',1024);'])

eval(['s_' sblfile1 '=gd_pows(' sblfile1 ',''pieces'',1,''resolution'',4,''window'',2)'])
eval(['s=edit_gd(s_' sblfile1 ',''ini'',ini_gd(s_' sblfile1 ')-' num2str(fr-ifr) ')'])
eval(['figure,semilogy(s)']),grid on
eval(['w_' sblfile1 '=gd_worm(' sblfile1 ',''freq'',' num2str(fr) ')'])
eval(['figure,plot(y_gd(w_' sblfile1 ')),hold on,plot(y_gd(w_' sblfile1 '),''r.'')']),grid on