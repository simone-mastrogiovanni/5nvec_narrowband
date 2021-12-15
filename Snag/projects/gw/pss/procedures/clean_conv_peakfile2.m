% clean_conv_peakfile2  "cleans" pia peak files using vbl files

nn=10/9.536743164062500e-004

cd k:\pss\virgo\pm\c7\

% piapeak2vbl(4000/4194304,4194304,'peakmap-C7.dat','peakmap-C7.vbl')
[spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,'peakmap-C7.vbl');

cd k:\pss\virgo\pm\sim7\

% piapeak2vbl(4000/4194304,4194304,'pm_c7_fake_s1.p05','pm_c7_fake_s1.vbl')

mask=crea_cleaningmask(peakfr,5,1.6181);
clean_piapeak(mask,'pm_c7_fake_s1.p05');

% piapeak2vbl(4000/4194304,4194304,'pm_c7_fake_s1_clean.p05','pm_c7_fake_s1_clean.vbl')