function out=check_fu_merge(fu_merge)
% checks full follow-up analysis
%   
%      out=check_fu_merge(full_fu) 
%
%   full_fu      as created by fu_full

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();
inp1=tit_underscore(inputname(1));

sourin=fu_merge.sourin;
sourout1=fu_merge.sourout1;
sourout2=fu_merge.sourout2;
sourout=fu_merge.sourout;

patches=fu_merge.patches;
kpatch=fu_merge.kpatch;
nlams=fu_merge.nlams;
[np,dum]=size(patches);
nbets=np/nlams;
ini=patches(1,1:2);
dx=[patches(2,1)-patches(1,1),patches(1+nlams,2)-patches(1,2)];

fprintf('sourin  : %.5f %.3e  %.2f %.2f \n',sourin.f0,sourin.df0,sourin.a,sourin.d)
fprintf('sourout1: %.5f %.3e  %.2f %.2f \n',sourout1.f0,sourout1.df0,sourout1.a,sourout1.d)
fprintf('sourout2: %.5f %.3e  %.2f %.2f \n',sourout2.f0,sourout2.df0,sourout2.a,sourout2.d)
fprintf('sourout : %.5f %.3e  %.2f %.2f  ecl.: %.2f %.2f \n',sourout.f0,sourout.df0,sourout.a,sourout.d,sourout.ecl)
fdoi=sourout.f0-sourin.f0;
out.unitfrd=sqrt(fu_merge.info1.run.fr.dnat^2+fu_merge.info2.run.fr.dnat^2);
doi=fdoi/out.unitfrd;
fprintf('  frequency distance sour in-out: %f (%f Hz)\n',doi,fdoi)

gpat_A=gd2ar(fu_merge.pat_A,nlams,nbets,ini,dx);
out.gpat_A=gpat_A;
gpat_f=gd2ar(fu_merge.pat_f,nlams,nbets,ini,dx);
out.gpat_f=gpat_f;
gpat_sd=gd2ar(fu_merge.pat_sd,nlams,nbets,ini,dx);
out.gpat_sd=gpat_sd;
plot(gpat_A);title('Amplitude'),xlabel('lambda'),ylabel('beta')
hold on,plot(patches(kpatch,1),patches(kpatch,2),'r+');
plot(gpat_f);title('Frequency'),xlabel('lambda'),ylabel('beta')
hold on,plot(patches(kpatch,1),patches(kpatch,2),'r+');
plot(gpat_sd);title('Spin-Down'),xlabel('lambda'),ylabel('beta')
hold on,plot(patches(kpatch,1),patches(kpatch,2),'r+');

pmraw=fu_merge.pmraw;
pmcorr=fu_merge.pmcorr;

hfdf=fu_merge.hfdf;
plot(hfdf);title('Hough Map'),xlabel('frequency (Hz)'),ylabel('Spin-Down')

[wwh,outwh]=ww_hist(4,0.00001,pmraw(2,:),pmraw(3,:),1);
[wwhc,outwhc]=ww_hist(4,0.00001,pmcorr(2,:),pmcorr(3,:),1);

out.wwh=wwh;
out.outwh=outwh;
out.wwhc=wwhc;
out.outwhc=outwhc;

fprintf('step1 mu = %f  sigma = %f   step2 mu = %f  sigma = %f \n',outwh.mu,outwh.sigma,outwhc.mu,outwhc.sigma)

fig1=figure;plot(wwh);hold on,plot(wwhc,'r');xlabel('Hz'),title(inp1)
out.fig1=fig1;

[wwh1,out1]=ww_hist_2D(4,[2,0.00002],pmraw(1:2,:),pmraw(3,:));title([inp1 ' WWH ']);
xlabel('MJD'),ylabel('Hz')
out.wwh1=wwh1;
out.outwh1=out1;
[wwh2,out2]=ww_hist_2D(4,[2,0.00002],pmcorr(1:2,:),pmcorr(3,:));title([inp1 ' WWH corr']);
xlabel('MJD'),ylabel('Hz')
out.wwh2=wwh2;
out.outwh2=out2;


function g=gd2ar(A,nlams,nbets,ini,dx);

g=reshape(A,nlams,nbets);
g=gd2(g);
g=edit_gd2(g,'ini',ini(1),'ini2',ini(2),'dx',dx(1),'dx2',dx(2));