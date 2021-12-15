% show_check_5vec_prob

nn=length(out_ch);

for i = 1:nn
    snrs(i)=out_ch{i}.snr;
    As(i)=out_ch{i}.muA;
    As_std(i)=out_ch{i}.stdA;
    muloss(i)=out_ch{i}.muloss;
    stdloss(i)=out_ch{i}.stdloss;
    mudist(i)=out_ch{i}.mudist;
    stddist(i)=out_ch{i}.stddist;
end

figure,loglog(snrs,1./As),grid on,hold on,loglog(snrs,1./As,'r.')
xlabel('snr'),title('estimated snr')
figure,semilogx(snrs,As_std./As.^2),grid on,hold on,semilogx(snrs,As_std./As.^2,'r.')
xlabel('snr'),title('uncertainty on estimated snr')
figure,loglog(snrs,1./As./(As_std./As.^2)),grid on,hold on,loglog(snrs,1./As./(As_std./As.^2),'r.')
xlabel('snr'),title('snr on estimated snr')

figure,loglog(snrs,muloss),grid on,hold on,loglog(snrs,muloss,'r.')
hold on,loglog(snrs,stdloss,'r'),grid on,hold on,loglog(snrs,stdloss,'.')
xlabel('snr'),title('expected loss and uncertainty')

figure,loglog(snrs,mudist),grid on,hold on,loglog(snrs,mudist,'r.')
hold on,loglog(snrs,stddist,'r'),grid on,hold on,loglog(snrs,stddist,'.')
xlabel('snr'),title('expected distance and uncertainty')
    