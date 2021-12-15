function out=sofinj_efficiency(sour,cs,nocs)
%
%       out=sofinj_efficiency(sour,cs,nocs)

% Snag Version 2.0 -June 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=[];

ssnr=sour(:,6);
ns=length(ssnr);
dsnr=cs(:,10);
nd=length(dsnr);
nsnr=nocs(:,9);
nn=length(nsnr);

typ=4;

[wwh1,out1]=ww_hist(typ,[.1,20,-1,2],log10(ssnr),1,1);
[wwh2,out2]=ww_hist(typ,[.1,20,-1,2],log10(dsnr),1,1);
[wwh3,out3]=ww_hist(typ,[.1,20,-1,2],log10(nsnr),1,1);

eff=wwh2./(wwh1+0.001);
n=n_gd(eff);
eff=sel_gd(eff,[0 0],[1 n-40],[0 0]);
out.eff=edit_gd(eff,'x',10.^x_gd(eff));

nodet=wwh3./(wwh1+0.001);
n=n_gd(nodet);
nodet=sel_gd(nodet,[0 0],[1 n-40],[0 0]);
out.nodet=edit_gd(nodet,'x',10.^x_gd(eff));

figure,semilogx(out.eff);grid on,hold on,semilogx(out.nodet,'r');
xlim([0.1 100]),xlabel('snr'),title('efficiency (red % no coin)')

out.hsource=wwh1;
out.hdetect=wwh2;
out.hnodet=wwh2;

% figure,semilogx(ssnr,out.eff,'.'),grid on