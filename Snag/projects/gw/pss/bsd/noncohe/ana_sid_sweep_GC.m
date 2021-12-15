function out=ana_sid_sweep_GC(fr1,bw,header,head2)
% fr1 initial frequency
% bw if > 0, new format with width (typically 10, 100,...)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('header','var')
    header='sidsGC';
end
if ~exist('head2','var')
    head2=header;
end
if bw > 0
    sidsL=sprintf('%s_%04d_%04d_%d_L',header,fr1,fr1+10,bw);
    sidsH=sprintf('%s_%04d_%04d_%d_H',header,fr1,fr1+10,bw);
else
    sidsL=sprintf('%s_%04d_%04d_L',header,fr1,fr1+10);
    sidsH=sprintf('%s_%04d_%04d_H',header,fr1,fr1+10);
end

sids_L=[head2 'L'];
sids_H=[head2 'H'];

eval(['load(''' sidsL ''');'])
eval(['sids_L=' sids_L ';'])
frL=sids_L.fr;
sidsigL=sids_L.sidsig;
sidnoisL=sids_L.sidnois;
sidratL=sidsigL./sidnoisL;
out.sidratL=sidratL;
% [raL,rpL]=v_ranking(sidratL);

eval(['load(''' sidsH ''');'])
eval(['sids_H=' sids_H ';'])
frH=sids_H.fr;
sidsigH=sids_H.sidsig;
sidnoisH=sids_H.sidnois;
sidratH=sidsigH./sidnoisH;
out.sidratH=sidratH;
% [raH,rpH]=v_ranking(sidratH);

figure,plot(frL,sidratL),grid on,title('L')
figure,plot(frH,sidratH),grid on,title('H')
figure,plot(frL,sidratL.*sidratH),grid on,title('L*H')

fprintf(' %f - %f Hz\n',fr1,fr1+10)

% [hiL,xhL]=hist(sidratL,500);
% figure,loglog(xhL,hiL),grid on,title('L')
% 
% [hiLl,xhLl]=hist(log10(sidratL),200);
% figure,semilogy(xhLl,hiLl),grid on,title('log L')

out1=log_norm_stat(sidratL,300);title('L')

% [hiH,xhH]=hist(sidratH,500);
% figure,loglog(xhH,hiH),grid on,title('H')
% 
% [hiHl,xhHl]=hist(log10(sidratH),200);
% figure,semilogy(xhHl,hiHl),grid on,title('log H')

out1=log_norm_stat(sidratH,300);title('log H')


% [hiLH,xhLH]=hist(sidratL.*sidratH,500);
% figure,loglog(xhLH,hiLH),grid on,title('LH')
% 
% [hiLHl,xhLHl]=hist(log10(sidratL.*sidratH),200);
% figure,semilogy(xhLHl,hiLHl),grid on,title('log LH')

out1=log_norm_stat(sidratL.*sidratH,300);title('LH')

pL=sort_p_rank(sidratL);
pH=sort_p_rank(sidratH);
P=1./(pL.*pH);

figure,semilogy(frL,1./pL,'x'),grid on,hold on,plot(frH,1./pH,'gx'),plot(frL,P,'ro'),
title([sidsL ' - ' sidsH]),xlabel('frequency'),ylabel('Ranking')
    
out.pL=pL;   
out.pH=pH;

[hP,xP]=hist(log10(P),200);
[hpL,xpL]=hist(log10(1./pL),200);
figure,semilogy(xP,hP,'c'),grid on,title('Ranking histogram (r L or H, b L*H)'),xlabel('log10(P)')
hold on,semilogy(xP,hP,'b.')
semilogy(xpL,hpL,'r')

out.prodp=mean(1./(pL.*pH))/(mean(1./pL)*mean(1./pH));
out.corrp=mean(1./(pL.*pH))/(std(1./pL)*std(1./pH));

if isfield(sids_L,'solsig') & isfield(sidsGCH,'solsig')   
    solsigL=sids_L.solsig;
    solnoisL=sids_L.solnois;
    solratL=solsigL./solnoisL;
    figure,semilogy(frL,sidratL,'g'),grid on,
    hold on,semilogy(frL,solratL),grid on,title('sol L')
     
    solsigH=sids_H.solsig;
    solnoisH=sids_H.solnois;
    solratH=solsigH./solnoisL;
    figure,semilogy(frL,sidratH,'g'),grid on,
    hold on,semilogy(frL,solratH),grid on,title('sol H')
    
    figure,semilogy(frL,sidratL.*sidratH,'g'),grid on
    hold on,semilogy(frL,solratL.*solratH),grid on,title('sol L*H')
    
    solpL=sort_p_rank(solratL);
    solpH=sort_p_rank(solratH);
    solP=1./(solpL.*solpH);

    figure,semilogy(frL,solP,'x'),grid on,hold on,plot(frL,P,'ro'),
    title('P (red) and solP'),xlabel('frequency'),ylabel('Ranking')

    [hP1,xP1]=hist(log10(solP),200);
    [hpL1,xpL1]=hist(log10(1./solpL),200);
    figure,semilogy(xP1,hP1,'c'),grid on,title('sol Ranking histogram (r L or H, b L*H)'),xlabel('log10(P)')
    hold on,semilogy(xP1,hP1,'b.')
    semilogy(xpL1,hpL1,'r')
    semilogy(xP,hP,'g')
    
    out.solratL=solratL;
    out.solratH=solratH;
    out.prodpsol=mean(1./(solpL.*solpH))/(mean(1./solpL)*mean(1./solpH));
    out.corrpsol=mean(1./(solpL.*solpH))/(std(1./solpL)*std(1./solpH));
    out.solpL=solpL;   
    out.solpH=solpH;
end
