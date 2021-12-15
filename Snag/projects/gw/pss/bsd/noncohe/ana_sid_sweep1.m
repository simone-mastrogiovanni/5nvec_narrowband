function out=ana_sid_sweep1(ipul,bw)
% 
%   ipul    hardware injection number 
%   bw      narrow bandwidth in units of 1/SD (typically 10)

SD=86164.09053083288;
epochO2=57870;
TOss=250; % giorni

puls=['pulsar_' num2str(ipul)];
sidsL=['sids_p' num2str(ipul) '_' num2str(bw) '_L'];
sidsH=['sids_p' num2str(ipul) '_' num2str(bw) '_H'];
    
eval([puls '=new_posfr(' puls ',epochO2);']);
eval(['pfr0=' puls '.f0;'])
eval(['pdfr0=' puls '.df0;'])
eval(['ph0=' puls '.h;'])

eval(['load(''' sidsL ''');'])
eval(['frL=' sidsL '.fr;'])
eval(['sidratL=' sidsL '.sidrat;'])

eval(['load(''' sidsH ''');'])
eval(['frH=' sidsH '.fr;'])
eval(['sidratH=' sidsH '.sidrat;'])

figure,plot(frL,sidratL),grid on,plot_lines(pfr0,sidratL),title('L')
figure,plot(frH,sidratH),grid on,plot_lines(pfr0,sidratH),title('H')
figure,plot(frL,sidratL.*sidratH),grid on,plot_lines(pfr0,sidratL.*sidratH),title('L*H')

out.sidratL=sidratL;
out.sidratHL=sidratH;

mul=mean(sidratL);
muh=mean(sidratH);
mulh=mean(sidratL.*sidratH);
sigl=std(sidratL);
sigh=std(sidratH);
siglh=std(sidratL.*sidratH);
mal=max(sidratL);
mah=max(sidratH);
malh=max(sidratL.*sidratH);

fprintf(' %s  %f  %e  %e  s.d.band: %f (1/SD)\n',puls,pfr0,pdfr0,ph0,abs(pdfr0)*TOss*86400*SD+5)
fprintf(' mul,std,snr= %f  %f  %f \n',mul,sigl,mal/sigl)
fprintf(' muh,std,snr= %f  %f  %f \n',muh,sigh,mah/sigh)
fprintf(' mulh,std,snr= %f  %f  %f \n',mulh,siglh,malh/siglh)

[hiL,xhL]=hist(sidratL,500);
figure,semilogy(xhL,hiL),grid on,title('L')

[hiH,xhH]=hist(sidratH,500);
figure,semilogy(xhH,hiH),grid on,title('H')

[hiLH,xhLH]=hist(sidratL.*sidratH,500);
figure,semilogy(xhLH,hiLH),grid on,title('LH')

pL=sort_p_rank(sidratL,eps*1000);
pH=sort_p_rank(sidratH,eps*1000);
P=1./(pL.*pH);

figure,semilogy(frL,1./pL,'x'),grid on,hold on,plot(frL,1./pH,'gx'),plot(frL,P,'ro'),
title([sidsL ' - ' sidsH]),xlabel('frequency'),ylabel('Ranking')
plot_lines(pfr0,P)
    
out.pL=pL;    
out.pH=pH;
out.P=P;

out.mul=mul;