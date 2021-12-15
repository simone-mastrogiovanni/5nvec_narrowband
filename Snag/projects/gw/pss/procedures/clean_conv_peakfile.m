% clean_conv_peakfile  "cleans" pia peak files using vbl files

nn=10/9.536743164062500e-004

cd o:\pss\virgo\pm\c7\               % CHANGE

% piapeak2vbl(4000/4194304,4194304,'peakmap-C7.dat','peakmap-C7.vbl')
[spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,'peakmap-C7.vbl');     % CHANGE
mask=crea_cleaningmask(peakfr,5,1.6181);

cd o:\pss\virgo\pm\f7\               % CHANGE
peakfile='pm_c7_fake_t80s1-slow'     % CHANGE

piapeak2vbl(4000/4194304,4194304,[peakfile '.p05'],[peakfile '.vbl'])

clean_piapeak(mask,[peakfile '.p05']);

piapeak2vbl(4000/4194304,4194304,[peakfile '_clean.p05'],[peakfile '_clean.vbl'])

copyfile([peakfile '.vbl'],['z:\pss\virgo\pm\f7\' peakfile '.vbl'],'f')                 % CHANGE
copyfile([peakfile '_clean.p05'],['z:\pss\virgo\pm\f7\' peakfile '_clean.p05'],'f')     % CHANGE
copyfile([peakfile '_clean.vbl'],['z:\pss\virgo\pm\f7\' peakfile '_clean.vbl'],'f')     % CHANGE