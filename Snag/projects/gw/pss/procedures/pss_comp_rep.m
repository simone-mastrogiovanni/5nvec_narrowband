% pss_comp_rep

pss_comp.tobs=365/3;
pss_comp.tcoh=1000;%48*3600;
pss_comp.nu0=600;
pss_comp.maxnu0=2000;
pss_comp.sdtau=10000;
pss_comp.minsdtau=10000;
pss_comp.noiseh=1.e-22;
pss_comp.frres=2;
pss_comp.skyres=1;
pss_comp.sdres=1;
pss_comp.houghkfl=20;
pss_comp.cohkfl=5000;

pss_comp.hfdf.nsd=200;
pss_comp.hfdf.maxNhfdf=1.e6;
pss_comp.hfdf.tcoh=pss_comp.tcoh;
pss_comp.hfdf.maxfr=1020;
pss_comp.hfdf.minfr=20;

pss_comp=pss_cp_sens(pss_comp);

pss_comp.tcoh=100*((100000/100).^(1/1000)).^(0:1000);
pss_comp=pss_cp_sens(pss_comp);

figure, semilogy(pss_comp.hnomsens,pss_comp.houghcp),grid on
% set(gca,'XDir','reverse')
hold on, semilogy(pss_comp.hsens1G,pss_comp.houghcp,'r'),grid on
% set(gca,'XDir','reverse')
axis tight
title('CP vs Nominal and 1G sensitivity (red)')
xlabel('Sensitivity')
ylabel('Hough computing power (Gflops)')

figure, loglog(pss_comp.hnomsens,pss_comp.houghcp),grid on
% set(gca,'XDir','reverse')
hold on, loglog(pss_comp.hsens1G,pss_comp.houghcp,'r'),grid on
% set(gca,'XDir','reverse')
axis tight
title('CP vs Nominal and 1G sensitivity (red)')
xlabel('Sensitivity')
ylabel('Hough computing power (Gflops)')

figure, loglog(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.houghcp,'r'),grid on
% set(gca,'XDir','reverse')
hold on 
% loglog(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.cohcp,'g'),grid on
% set(gca,'XDir','reverse')
loglog(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.houghcp+pss_comp.cohcp),grid on
% set(gca,'XDir','reverse')
axis tight
title('CP vs 1G sfdb normalized sensitivity')
xlabel('Normalized sensitivity')
ylabel('Hough (r), coherent (g) and total (b) computing power (Gflops)')

figure, semilogx(pss_comp.houghcp+pss_comp.cohcp,pss_comp.hsens1G./pss_comp.hsfdbsens1G),grid on
% set(gca,'YDir','reverse')
axis tight
title('1G sfdb normalized sensitivity vs CP')
ylabel('Normalized sensitivity')
xlabel('Computing power (Gflops)')

figure, semilogy(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.houghcp,'r'),grid on
% set(gca,'XDir','reverse')
hold on 
% semilogy(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.cohcp,'g'),grid on
% set(gca,'XDir','reverse')
semilogy(pss_comp.hsens1G./pss_comp.hsfdbsens1G,pss_comp.houghcp+pss_comp.cohcp),grid on
% set(gca,'XDir','reverse')
axis tight
title('CP vs 1G sfdb normalized sensitivity')
xlabel('Normalized sensitivity')
ylabel('Hough (r), coherent (g) and total (b) computing power (Gflops)')

figure, loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.houghcp,'r'),grid on
axis tight, hold on
loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.cohcp,'g'),grid on
loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.houghcp+pss_comp.cohcp),grid on
axis tight
title('CP vs Normalized coherent analysis time')
xlabel('Normalized coherent analysis time')
ylabel('Hough (r), coherent (g) and total (b) computing power (Gflops)')

figure, semilogy(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.houghcp,'r'),grid on
axis tight, hold on
semilogy(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.houghcp+pss_comp.cohcp),grid on
axis tight
title('CP vs Normalized coherent analysis time')
xlabel('Normalized coherent analysis time')
ylabel('Hough (r), coherent (g) and total (b) computing power (Gflops)')

figure,semilogx(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.redcoef),grid on
axis tight
title('Reduction coefficient vs Normalized coherent analysis time')
xlabel('Normalized coherent analysis time')
ylabel('1G h sensitivity reduction coefficient')

figure,loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.hsens1G),grid on
hold on,loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.hnomsens,'r'),grid on
axis tight
title('Sensitivity vs Normalized coherent analysis time')
xlabel('Normalized coherent analysis time')
ylabel('Nominal (r) and 1G sensitivity (b)')

figure,loglog(pss_comp.tcoh./pss_comp.sfdbtlen,pss_comp.ntot),grid on
axis tight
title('Number of points in par. space vs Normalized coherent analysis time')
xlabel('Normalized coherent analysis time')
ylabel('Number of points in parameter space')

figure, loglog(pss_comp.hsens1G,pss_comp.npatch),grid on
% set(gca,'XDir','reverse')
axis tight
title('Number of patches')

% dsens=diff(pss_comp.hsens1G);
% dcp=diff(pss_comp.houghcp);
% 
% figure,plot(dsens,dcp)