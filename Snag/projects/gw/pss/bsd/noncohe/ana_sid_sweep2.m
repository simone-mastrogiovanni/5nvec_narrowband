function out=ana_sid_sweep2(ipul,bw,integ)
% 
%   ipul    hardware injection number 
%   bw      narrow bandwidth in units of 1/SD (typically 10)
%   integ   integration values (ex.: [1 3 10 30 100] ; def 1)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
epochO2=57870;
TOss=250; % giorni

if ~exist('integ','var')
    integ=1;
end

N=length(integ);

puls=['pulsar_' num2str(ipul)];
sidsL=['sids2_p' num2str(ipul) '_' num2str(bw) '_L'];
sidsH=['sids2_p' num2str(ipul) '_' num2str(bw) '_H'];
    
eval([puls '=new_posfr(' puls ',epochO2);']);
eval(['pfr0=' puls '.f0;'])
eval(['pdfr0=' puls '.df0;'])
eval(['ph0=' puls '.h;'])

eval(['load(''' sidsL ''');'])
eval(['frL=' sidsL '.fr;'])
eval(['sidsigL=' sidsL '.sidsig;'])
eval(['sidnoisL=' sidsL '.sidnois;'])
eval(['sidL=' sidsL ';'])

eval(['load(''' sidsH ''');'])
eval(['frH=' sidsH '.fr;'])
eval(['sidsigH=' sidsH '.sidsig;'])
eval(['sidnoisH=' sidsH '.sidnois;'])
eval(['sidH=' sidsH ';'])

for i = 1:N
    windowSize=integ(i);
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    sidsigL1=filter(b,a,sidsigL);
    sidnoisL1=filter(b,a,sidnoisL);
    sidsigH1=filter(b,a,sidsigH);
    sidnoisH1=filter(b,a,sidnoisH);
    
    ti0=num2str(windowSize*bw);
    show_sids(frL,sidsigL1,sidnoisL1,puls,pfr0,[ti0 ' L'])
    show_sids(frH,sidsigH1,sidnoisH1,puls,pfr0,[ti0 ' H'])
    show_sids(frL,sidsigL1.*sidsigH1,sidnoisL1.*sidnoisH1,puls,pfr0,[ti0 ' L*H'])

    pL=sort_p_rank(sidsigL1,eps*1000);
    pH=sort_p_rank(sidsigH1,eps*1000);
    P=1./(pL.*pH);

    figure,semilogy(frL,1./pL,'x'),grid on,hold on,semilogy(frL,1./pH,'gx'),semilogy(frL,P,'ro'),
    title([sidsL ' - ' sidsH ' wband ' num2str(windowSize*bw)]),xlabel('frequency'),ylabel('Ranking')
    plot_lines(pfr0,P)
end

out.sidsigL=sidsigL;
out.sidsigHL=sidsigH;
mul=mean(sidsigL);
muh=mean(sidsigH);
mulh=mean(sidsigL.*sidsigH);
sigl=std(sidsigL);
sigh=std(sidsigH);
siglh=std(sidsigL.*sidsigH);
mal=max(sidsigL);
mah=max(sidsigH);
malh=max(sidsigL.*sidsigH);

fprintf(' %s  %f  %e  %e  s.d.band: %f (1/SD)\n',puls,pfr0,pdfr0,ph0,abs(pdfr0)*TOss*86400*SD+5)
fprintf(' mul,std,snr= %f  %f  %f \n',mul,sigl,mal/sigl)
fprintf(' muh,std,snr= %f  %f  %f \n',muh,sigh,mah/sigh)
fprintf(' mulh,std,snr= %f  %f  %f \n',mulh,siglh,malh/siglh)
  
out.pL=pL;    
out.pH=pH;
out.P=P;

out.mul=mul; 

%---------------------------------------------------------------

if isfield(sidL,'solsig') && isfield(sidH,'solsig') 
    solsigL=sidL.solsig;
    solnoisL=sidL.solnois;
    
    solsigH=sidH.solsig;
    solnoisH=sidH.solnois;
    
    show_sids(frL,solsigL,solnoisL,puls,pfr0,[ti0 'sol L'])
    show_sids(frH,solsigH,solnoisH,puls,pfr0,[ti0 'sol H'])
    show_sids(frL,solsigL.*solsigH,solnoisL.*solnoisH,puls,pfr0,[ti0 ' L*H'])

    pL1=sort_p_rank(solsigL,eps*1000);
    pH1=sort_p_rank(solsigH,eps*1000);
    P1=1./(pL1.*pH1);

    figure,semilogy(frL,P,'x'),hold on,semilogy(frL,P1,'ro'),grid on
    title([sidsL ' - ' sidsH ' wband ' num2str(windowSize*bw)]),xlabel('frequency'),ylabel('sol Ranking')
    plot_lines(pfr0,P)
else
    disp('no solar info')
end

function show_sids(fr,sidsig,sidnois,puls,pfr0,tit)

figure,semilogy(fr,sidsig),grid on,plot_lines(pfr0,sidsig),title([puls ' ' tit])
hold on,semilogy(fr,sidnois,'r')

figure,semilogy(fr,sidsig./sidnois),grid on,plot_lines(pfr0,sidsig./sidnois),title([puls ' ratio ' tit])

[hi,xh]=hist(sidsig,10000);
figure,loglog(xh,hi),grid on,title([puls ' sig ' tit])
[hi,xh]=hist(sidsig./sidnois,10000);
figure,loglog(xh,hi),grid on,title([puls ' ratio ' tit])
