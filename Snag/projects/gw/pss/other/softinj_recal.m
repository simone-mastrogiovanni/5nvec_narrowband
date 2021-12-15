function out=softinj_recal(cs)
% softinj recalibration function
%
%   out=softinj_recal(cs)

ssnr=cs(:,10);
bg=cs(:,9)./cs(:,10);
detsnr=cs(:,8)./bg;
figure,loglog(detsnr,ssnr,'.'),grid on,xlabel('detection snr'),ylabel('injection snr')
title('softinj recalibration'),xlim([1,10])

out.ratio=detsnr./ssnr;

figure,loglog(ssnr,out.ratio,'.'),grid on,xlabel('inj snr'),ylabel('det/inj snr')
title('softinj recalibration')

figure,loglog(detsnr,out.ratio,'.'),grid on,xlabel('det snr'),ylabel('det/inj snr')
title('softinj recalibration'),xlim([1,10])