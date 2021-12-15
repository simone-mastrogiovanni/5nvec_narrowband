function out=fu_ana_3(fum)
% fu_merge alternative analysis
%
%     out=fu_ana_2(fum)
%
%   fum   fu_merge output structure
%

% Snag Version 2.0 - February 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

inp1=tit_underscore(inputname(1));

sigband=2;

sourin=fum.sourin;
sourout1=fum.sourout1;
sourout2=fum.sourout2;
sourout=fum.sourout;

fprintf('sourin  : %.5f %.3e  %.2f %.2f \n',sourin.f0,sourin.df0,sourin.a,sourin.d)
fprintf('sourout1: %.5f %.3e  %.2f %.2f \n',sourout1.f0,sourout1.df0,sourout1.a,sourout1.d)
fprintf('sourout2: %.5f %.3e  %.2f %.2f \n',sourout2.f0,sourout2.df0,sourout2.a,sourout2.d)
fprintf('sourout : %.5f %.3e  %.2f %.2f  ecl.: %.2f %.2f \n',sourout.f0,sourout.df0,sourout.a,sourout.d,sourout.ecl)

fdoi=sourout.f0-sourin.f0;
out.unitfrd=sqrt(fum.info1.run.fr.dnat^2+fum.info2.run.fr.dnat^2);
doi=fdoi/out.unitfrd;
fprintf('  frequency distance sour in-out: %f (%f Hz)\n',doi,fdoi)
out.dfrinout=fdoi;
out.normdfrinout=doi;


peaks=fum.pmraw;
A1(:,3)=peaks(3,:);
A1(:,2)=peaks(2,:);
A1(:,1)=peaks(1,:);
tits={sprintf('source at %f raw',sourin.f0),'MJD','Hz'};
color_points(A1,0,tits);

peaks=fum.pmcorr;
A2(:,3)=peaks(3,:);
A2(:,2)=peaks(2,:);
A2(:,1)=peaks(1,:);
tits={sprintf('source at %f corrected',sourin.f0),'MJD','Hz'};
color_points(A2,0,tits);

patch=fum.patches(fum.kpatch,:);
pin.pm=fum.pmraw;
pin.fu=fum.fu;
PM=fu_patch(pin,fum.cont1,patch);
N=length(PM);

tsep=max(fum.cont1.time(1,:))+10;
out.tsep=tsep;

ii=find(PM(1,:) < tsep);
N1=max(ii);
PM1=PM(:,1:N1);
PM2=PM(:,N1+1:N);
pmraw1=fum.pmraw(:,1:N1);
pmraw2=fum.pmraw(:,N1+1:N);
N2=N-N1;
out.N1=N1;
out.N2=N2;

fres=0.00001;
fr=fum.sourout.f0;

[wwh1,outwh1]=ww_hist(4,fres,pmraw1(2,:),pmraw1(3,:),1);
[wwh1c,outwh1c]=ww_hist(4,fres,PM1(2,:),PM1(3,:),1);
[wwh2,outwh2]=ww_hist(4,fres,pmraw2(2,:),pmraw2(3,:),1);
[wwh2c,outwh2c]=ww_hist(4,fres,PM2(2,:),PM2(3,:),1);
[wwh3,outwh3]=ww_hist(4,fres,fum.pmraw(2,:),fum.pmraw(3,:),1);
[wwh3c,outwh3c]=ww_hist(4,fres,PM(2,:),PM(3,:),1);

% ww2D1c=ww_hist_2D(4,[1 fres],PM1(1:2,:),PM1(3,:));
% ww2D2c=ww_hist_2D(4,[1 fres],PM2(1:2,:),PM2(3,:));

figure,plot(pmraw1(1,:),pmraw1(2,:),'.')
hold on,plot(PM1(1,:),PM1(2,:),'r.');grid on,ylim([fr-40*fres fr+40*fres]);
title([inp1 ' first run correct pm '])
figure,plot(pmraw2(1,:),pmraw2(2,:),'.')
hold on,plot(PM2(1,:),PM2(2,:),'r.');grid on,ylim([fr-40*fres fr+40*fres]);
title([inp1 ' second run correct pm '])

out.wwh1=wwh1;
out.wwh1c=wwh1c;
out.wwh2=wwh2;
out.wwh2c=wwh2c;
out.wwh=wwh3;
out.wwhc=wwh3c;

xh=0:0.025:6;
out.stat.xh=xh;

ii=find(pmraw1(2,:) < fr-10*fres | pmraw1(2,:) > fr+10*fres);
y=y_gd(wwh1);
y=y(ii);
out.stat.hist1=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.mean1=mean(y(ii));
out.stat.std1=std(y(ii));
out.stat.dof1=2*(out.stat.mean1/out.stat.std1).^2;
out.stat.skew1=skewness(y);
out.stat.kurt1=kurtosis(y);
absc=[fum.sourin.f0-sigband*fum.sourin_unc.f0,fum.sourin.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymax1,out.stat.fmax1]=max(sel_gd(wwh1,0,0,absc));
out.stat.CR1=(out.stat.ymax1-out.stat.mean1)/out.stat.std1;
y=y_gd(wwh1);
interv=round((absc(2)-absc(1))/dx_gd(wwh1));
out.stat.p1=p_max_interv(y,out.stat.ymax1,interv);

ii=find(pmraw2(2,:) < fr-10*fres | pmraw2(2,:) > fr+10*fres);
y=y_gd(wwh2);
y=y(ii);
out.stat.hist2=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.mean2=mean(y(ii));
out.stat.std2=std(y(ii));
out.stat.dof2=2*(out.stat.mean2/out.stat.std2).^2;
out.stat.skew2=skewness(y);
out.stat.kurt2=kurtosis(y);
absc=[fum.sourin.f0-sigband*fum.sourin_unc.f0,fum.sourin.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymax2,out.stat.fmax2]=max(sel_gd(wwh2,0,0,absc));
out.stat.CR2=(out.stat.ymax2-out.stat.mean2)/out.stat.std2;
y=y_gd(wwh2);
interv=round((absc(2)-absc(1))/dx_gd(wwh2));
out.stat.p2=p_max_interv(y,out.stat.ymax2,interv);

ii=find(fum.pmraw(2,:) < fr-10*fres | fum.pmraw(2,:) > fr+10*fres);
y=y_gd(wwh3);
y=y(ii);
out.stat.hist=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.mean=mean(y(ii));
out.stat.std=std(y(ii));
out.stat.dof=2*(out.stat.mean/out.stat.std).^2;
out.stat.skew=skewness(y);
out.stat.kurt=kurtosis(y);
absc=[fum.sourin.f0-sigband*fum.sourin_unc.f0,fum.sourin.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymax,out.stat.fmax]=max(sel_gd(wwh3,0,0,absc));
out.stat.CR=(out.stat.ymax-out.stat.mean)/out.stat.std;
y=y_gd(wwh3);
interv=round((absc(2)-absc(1))/dx_gd(wwh3));
out.stat.p=p_max_interv(y,out.stat.ymax,interv);

% % figure,ph1=stairs(xh,out.stat.hist1);grid on,hold on,stairs(xh,out.stat.hist2,'r'),stairs(xh,out.stat.hist,'k')
% % title('Raw final spectra histograms')
% % ax=gca;ax.YScale='log';

ii=find(PM1(2,:) < fr-10*fres | PM1(2,:) > fr+10*fres);
y=y_gd(wwh1c);
y=y(ii);
out.stat.hist1c=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.mean1c=mean(y(ii));
out.stat.std1c=std(y(ii));
out.stat.dof1c=2*(out.stat.mean1c/out.stat.std1c).^2;
out.stat.skew1c=skewness(y);
out.stat.kurt1c=kurtosis(y);
absc=[fum.sourout1.f0-sigband*fum.sourin_unc.f0,fum.sourout1.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymax1c,out.stat.fmax1c]=max(sel_gd(wwh1c,0,0,absc));
out.stat.CR1c=(out.stat.ymax1c-out.stat.mean1c)/out.stat.std1c;
y=y_gd(wwh1c);
interv=round((absc(2)-absc(1))/dx_gd(wwh1c));
out.stat.p1c=p_max_interv(y,out.stat.ymax1c,interv);

ii=find(PM2(2,:) < fr-10*fres | PM2(2,:) > fr+10*fres);
y=y_gd(wwh2c);
y=y(ii);
out.stat.hist2c=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.mean2c=mean(y(ii));
out.stat.std2c=std(y(ii));
out.stat.dof2c=2*(out.stat.mean2c/out.stat.std2c).^2;
out.stat.skew2c=skewness(y);
out.stat.kurt2c=kurtosis(y);
absc=[fum.sourout2.f0-sigband*fum.sourin_unc.f0,fum.sourout2.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymax2c,out.stat.fmax2c]=max(sel_gd(wwh2c,0,0,absc));
out.stat.CR2c=(out.stat.ymax2c-out.stat.mean2c)/out.stat.std2c;
y=y_gd(wwh2c);
interv=round((absc(2)-absc(1))/dx_gd(wwh2c));
out.stat.p2c=p_max_interv(y,out.stat.ymax2c,interv);

ii=find(PM(2,:) < fr-10*fres | PM(2,:) > fr+10*fres);
y=y_gd(wwh3c);
y=y(ii);
out.stat.histc=hist(y/mean(y),xh);
ii=find(y>0);
out.stat.meanc=mean(y(ii));
out.stat.stdc=std(y(ii));
out.stat.dofc=2*(out.stat.meanc/out.stat.stdc).^2;
out.stat.skewc=skewness(y);
out.stat.kurtc=kurtosis(y);
absc=[fum.sourout.f0-sigband*fum.sourin_unc.f0,fum.sourout.f0+sigband*fum.sourin_unc.f0];
[out.stat.ymaxc,out.stat.fmaxc]=max(sel_gd(wwh3c,0,0,absc));
out.stat.CRc=(out.stat.ymaxc-out.stat.meanc)/out.stat.stdc;
y=y_gd(wwh3c);
interv=round((absc(2)-absc(1))/dx_gd(wwh3c));
out.stat.pc=p_max_interv(y,out.stat.ymaxc,interv);

% figure,stairs(xh,out.stat.hist1c),grid on,hold on,stairs(xh,out.stat.hist2c,'r'),stairs(xh,out.stat.histc,'k')
% title('Corrected final spectra histograms')
% ax=gca;ax.YScale='log';

Dfr=0.0010;

% figure,plot(wwh1/out.stat.mean1,wwh1c/out.stat.mean1c);title([inp1 ' First run, raw and corr'])
% hold on,plot([fr fr],[0 max(wwh1c)/out.stat.mean1c],'g');xlim([fr-Dfr fr+Dfr]);
% figure,plot(wwh2/out.stat.mean2,wwh2c/out.stat.mean2c);title([inp1 ' Second run, raw and corr'])
% hold on,plot([fr fr],[0 max(wwh2c)/out.stat.mean2c],'g');xlim([fr-Dfr fr+Dfr]);

figure;plot(wwh1/out.stat.mean1,wwh2/out.stat.mean2,wwh3/out.stat.mean);title([inp1 ' First and second run and sum, raw'])
hold on,plot([fr fr],[0 max(wwh3/out.stat.mean)],'g');xlim([fr-Dfr fr+Dfr]);
figure,plot(wwh1c/out.stat.mean1c,wwh2c/out.stat.mean2c,wwh3c/out.stat.meanc);title([inp1 ' First and second run and sum, corrected'])
hold on,plot([fr fr],[0 max(wwh3c/out.stat.meanc)],'g');xlim([fr-Dfr fr+Dfr]);

plot(fum.hfdf);xlim([fr-6*Dfr fr+6*Dfr]);

fprintf('\n              Results  \n\n')
fprintf('sourin  : %.5f %.3e  %.2f %.2f \n',sourin.f0,sourin.df0,sourin.a,sourin.d)
fprintf('  CR raw : %f   p=%f   amp %f\n',out.stat.CR,out.stat.p,out.stat.ymax)
fprintf('sourout1: %.5f %.3e  %.2f %.2f \n',sourout1.f0,sourout1.df0,sourout1.a,sourout1.d)
fprintf('  CR raw : %f   p=%f   CR corr. : %f   p=%f \n',out.stat.CR1,out.stat.p1,out.stat.CR1c,out.stat.p1c)
fprintf('sourout2: %.5f %.3e  %.2f %.2f \n',sourout2.f0,sourout2.df0,sourout2.a,sourout2.d)
fprintf('  CR raw : %f   p=%f   CR corr. : %f   p=%f \n',out.stat.CR2,out.stat.p2,out.stat.CR2c,out.stat.p2c)
fprintf('sourout : %.5f %.3e  %.2f %.2f  ecl.: %.2f %.2f \n',sourout.f0,sourout.df0,sourout.a,sourout.d,sourout.ecl)
fprintf('  CR corr. : %f   p=%f   amp %f  frequency: %.6f \n\n',out.stat.CRc,out.stat.pc,out.stat.ymaxc,out.stat.fmaxc)

