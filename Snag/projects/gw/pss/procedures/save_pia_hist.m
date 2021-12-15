% template m file save_pia_hist
%

load hist-c7_nothr.dat % modify 

hist__x=hist_c7_nothr(:,1); % modify right
hist__y=hist_c7_nothr(:,3); % modify right

figure, loglog(hist__x,hist__y)

hist_c7_nothr=gd(hist__y); % modify left
hist_c7_nothr=edit_gd(hist_c7_nothr,'dx',0.05,'capt','equalized spectra peak histogram') % modify 2

sds_writegd('','esp_peak_hist_c7_nothr.sds',hist_c7_nothr) % modify 2


% load hist-c7-005.txt % modify 
% 
% hist__x=hist_c7_005(:,1); % modify right
% hist__y=hist_c7_005(:,3); % modify right
% 
% figure, loglog(hist__x,hist__y)
% 
% hist_c7=gd(hist__y); % modify left
% hist_c7=edit_gd(hist_c7,'dx',0.05,'capt','equalized spectra peak histogram') % modify 2
% 
% sds_writegd('','esp_peak_hist_c7.sds',hist_c7) % modify 2