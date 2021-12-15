% test_check_gauss_1

N=1000;
clear nn ssig ssigmf smf msig msigmf mmf sig rawsig sigmf mf
ampgauss=1;
percdist=0.01;percdist=0
% ampdist=1/percdist;
ampdist=100;
% percdist=0;

for ii = 1:50
    NN=round(N*(1.15^ii));
    nn(ii)=NN;
    ndist=ceil(NN*percdist);
    for i = 1:100
        r=ampgauss*randn(1,NN);
        r(1:ndist)=r(1:ndist)*ampdist;
        rawsig(i)=std(r);
        [sig(i),sigmf(i),mf(i)]=check_gauss(r,20);
    end
    mrsig(ii)=mean(rawsig);
    srsig(ii)=std(rawsig);
    msig(ii)=mean(sig);
    ssig(ii)=std(sig);
    msigmf(ii)=mean(sigmf);
    ssigmf(ii)=std(sigmf);
    mmf(ii)=mean(mf);
    smf(ii)=std(mf);
    disp(sprintf(' %d NN = %d sigmf : %f  %f',ii,NN,msigmf(ii),ssigmf(ii)))
end

figure,loglog(nn,ssig),hold on,grid on,loglog(nn,ssigmf,'r'),loglog(nn,smf,'g'),loglog(nn,srsig,'k')
figure,loglog(nn,abs(msig-ampgauss)),hold on,grid on,loglog(nn,abs(msigmf-ampgauss),'r'),loglog(nn,mmf,'g'),loglog(nn,abs(mrsig-ampgauss),'k')
figure,loglog(nn,ssig,'k--','LineWidth',2),hold on,grid on,loglog(nn,ssigmf,'k:','LineWidth',2),loglog(nn,srsig,'k','LineWidth',2)
figure,loglog(nn,abs(msig-ampgauss),'k--','LineWidth',2),hold on,grid on,loglog(nn,abs(msigmf-ampgauss),'k:','LineWidth',2),loglog(nn,abs(mrsig-ampgauss),'k','LineWidth',2)
% disp(sprintf(' sig : %f  %f',mean(sig),std(sig)))
% disp(sprintf(' sigmf : %f  %f',mean(sigmf),std(sigmf)))
% disp(sprintf(' mf : %f  %f',mean(mf),std(mf)))
