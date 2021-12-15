% ex_bsd_event
%
% data extraction in a band [30 300] Hz
% ±5 min around the exact minute
%
% whitening filter and time resolution enhancement
% complex to real conversion

framp=300
tamp=1

tic

MJD=57279.410247905;
mjd_day=floor(MJD);
mjd_min=floor((MJD-mjd_day)*1440)/1440;
min5=5/1440;
t1=mjd_day+mjd_min-min5; mjd2s(t1)
t2=mjd_day+mjd_min+min5; mjd2s(t2)

[bsd_outL,BSD_tab_outL,outL]=bsd_access('I:','ligol','O1',[t1 t2],[30 320],3);
[bsd_outH,BSD_tab_outH,outH]=bsd_access('I:','ligoh','O1',[t1 t2],[30 320],3);

disp('Data extraction'),toc

[whL,filthL]=bsd_frfilt(bsd_outL,'white');
[whH,filthH]=bsd_frfilt(bsd_outH,'white');

[whL_norm,knormL,gausL]=filt_renorm(filthL,bsd_outL,framp,tamp);
[whH_norm,knormH,gausH]=filt_renorm(filthH,bsd_outH,framp,tamp);

figure;plot(whL),hold on,plot(whH,'r');
figure;plot(whL_norm),hold on,plot(whH_norm,'r'); title('normalized')

WHL=bsd_resenh(whL,10);
WHH=bsd_resenh(whH,10);

WHL_norm=bsd_resenh(whL_norm,10);
WHH_norm=bsd_resenh(whH_norm,10);

figure;plot(WHL);hold on;plot(WHH,'r');plot(whL,'r.');plot(whH,'b.')
figure;plot(WHL_norm);hold on;plot(WHH_norm,'r');plot(whL_norm,'r.');plot(whH_norm,'b.'); title('normalized')

rWHL=bsd_real(WHL);
rWHH=bsd_real(WHH);
figure;plot(rWHL);hold on;plot(rWHH,'r');

rWHL_norm=bsd_real(WHL_norm);
rWHH_norm=bsd_real(WHH_norm);
figure;plot(rWHL_norm);hold on;plot(rWHH_norm,'r');


mjd2s(t1),mjd2s(t2)

disp('End'),toc