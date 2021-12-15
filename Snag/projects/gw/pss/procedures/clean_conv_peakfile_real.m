% clean_conv_peakfile_real  "cleans" pia peak files using vbl files

nn=10/9.536743164062500e-004

cd o:\pss\virgo\pm\wsr7\               % CHANGE
peakfile='pm_wsr7_s1'                  % CHANGE

piapeak2vbl(4000/4194304,4194304,[peakfile '.p05'],[peakfile '.vbl'])
[spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,[peakfile '.vbl']);     % CHANGE
mask=crea_cleaningmask(peakfr,5,1.6181);

clean_piapeak(mask,[peakfile '.p05']);

piapeak2vbl(4000/4194304,4194304,[peakfile '_clean.p05'],[peakfile '_clean.vbl'])

copyfile([peakfile '.vbl'],['z:\pss\virgo\pm\wsr7\' peakfile '.vbl'],'f')                 % CHANGE
copyfile([peakfile '_clean.p05'],['z:\pss\virgo\pm\wsr7\' peakfile '_clean.p05'],'f')     % CHANGE
copyfile([peakfile '_clean.vbl'],['z:\pss\virgo\pm\wsr7\' peakfile '_clean.vbl'],'f')     % CHANGE