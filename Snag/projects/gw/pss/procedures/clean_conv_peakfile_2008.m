% clean_conv_peakfile_2008  "cleans" pia peak files using vbl files

cd O:\pss\virgo\pm\VSR1-v2               % CHANGE

piapeak2vbl_3(4096/4194304,4194304,'pm_VSR1_20070518-4.p05','pm_VSR1_20070518-4.vbl')
% [spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,'pm_VSR1_20070518-5.vbl');     % CHANGE
% mask=crea_cleaningmask(peakfr,5,1.6181);
% 
% cd o:\pss\virgo\pm\f7\               % CHANGE
% peakfile='pm_c7_fake_t80s1-slow'     % CHANGE
% 
% piapeak2vbl(4000/4194304,4194304,[peakfile '.p05'],[peakfile '.vbl'])
% 
% clean_piapeak(mask,[peakfile '.p05']);
% 
% piapeak2vbl(4000/4194304,4194304,[peakfile '_clean.p05'],[peakfile '_clean.vbl'])
% 
% copyfile([peakfile '.vbl'],['z:\pss\virgo\pm\f7\' peakfile '.vbl'],'f')                 % CHANGE
% copyfile([peakfile '_clean.p05'],['z:\pss\virgo\pm\f7\' peakfile '_clean.p05'],'f')     % CHANGE
% copyfile([peakfile '_clean.vbl'],['z:\pss\virgo\pm\f7\' peakfile '_clean.vbl'],'f')     % CHANGE