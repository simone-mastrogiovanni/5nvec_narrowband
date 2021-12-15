function [snr roc]=mc_exp_mixt(arat,h0,verb,N)
% MC_EXP_MIXT  montecarlo for exponential mixtures
%              produces histograms, ROCs and quadratic SNRs
%
%        snr=mc_exp_mixt(arat,h0,verb)
%
%     arat    A ratio (between the lin gain of the 2 modes)
%     h0      amplitude of the signal
%     verb    verbosity (0,1,2)
%     N       sample dimension (def 1000000)
%
%     snr     1  simple sum
%             2  equi-noise (F statistics)
%             3  wiener
%             4  max mode
%             5  ("0") natural
%             6  +
%             7  x
%     roc     ROC figures

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('N','var')
    N=1000000;
end
A1=arat;
A2=1;
if A1 < A2
    aa=A1;
    A1=A2;
    A2=aa;
end

c1=A1/sqrt(A1^2+A2^2);
c2=A2/sqrt(A1^2+A2^2);
A1=c1;
A2=c2;

dx=0.02;
xmax=100;
xx=0:dx:xmax;
M=length(xx);

n1=(randn(1,N)+1j*randn(1,N))/A1;
n2=(randn(1,N)+1j*randn(1,N))/A2;
sn1=n1+h0^2;
sn2=n2+h0^2;

snr0=(mean(abs(sn1).^2+abs(sn2).^2)-mean(abs(n1).^2+abs(n2).^2))/mean(abs(n1).^2+abs(n2).^2);

mn1=(abs(n1).^2+abs(n2).^2)/20;
mn2=(c1^2)*abs(n1).^2+(c2^2)*abs(n2).^2;
mn3=(c1^4)*abs(n1).^2+(c2^4)*abs(n2).^2;
mn4=abs(n1).^2;

msn1=(abs(sn1).^2+abs(sn2).^2)/20;
msn2=(c1^2)*abs(sn1).^2+(c2^2)*abs(sn2).^2;
msn3=(c1^4)*abs(sn1).^2+(c2^4)*abs(sn2).^2;
msn4=abs(sn1).^2;

[hn1,xn1]=hist(mn1,xx);
[hsn1,xsn1]=hist(msn1,xx);
if verb > 1
    figure,plot(xn1,hn1),hold on, grid on,plot(xsn1,hsn1,'r')
    figure,semilogy(xn1,hn1),hold on, grid on,semilogy(xsn1,hsn1,'r')
end
snr1=(mean(msn1)-mean(mn1))/mean(mn1);

[hn2,xn2]=hist(mn2,xx);
[hsn2,xsn2]=hist(msn2,xx);
if verb > 1
    figure,plot(xn2,hn2),hold on grid,plot(xsn2,hsn2,'r')
    figure,semilogy(xn2,hn2),hold on,grid on,semilogy(xsn2,hsn2,'r')
end
snr2=(mean(msn2)-mean(mn2))/mean(mn2);

[hn3,xn3]=hist(mn3,xx);
[hsn3,xsn3]=hist(msn3,xx);
if verb > 1
    figure,plot(xn3,hn3),hold on,grid on,plot(xsn3,hsn3,'r')
    figure,semilogy(xn3,hn3),hold on,grid on,semilogy(xsn3,hsn3,'r')
end
snr3=(mean(msn3)-mean(mn3))/mean(mn3);

[hn4,xn4]=hist(mn4,xx);
[hsn4,xsn4]=hist(msn4,xx);
if verb > 1
    figure,plot(xn4,hn4),hold on,grid on,plot(xsn4,hsn4,'r')
    figure,semilogy(xn4,hn4),hold on,grid on,semilogy(xsn4,hsn4,'r')
end
snr4=(mean(msn4)-mean(mn4))/mean(mn4);

snr(1)=snr1;
snr(2)=snr2;
snr(3)=snr3;
snr(4)=snr4;
snr(5)=snr0;
snr(6)=(mean(abs(sn1).^2)-mean(abs(n1).^2))/mean(abs(n1).^2);
snr(7)=(mean(abs(sn2).^2)-mean(abs(n2).^2))/mean(abs(n2).^2);

fprintf('SNR 1,2,3,4 : %f %f %f %f \n',snr1,snr2,snr3,snr4)

fa1=cumsum(hn1(M:-1:1));fa1=fa1/fa1(M);fa1=fa1(M:-1:1);
det1=cumsum(hsn1(M:-1:1));det1=det1/det1(M);det1=det1(M:-1:1);
fa2=cumsum(hn2(M:-1:1));fa2=fa2/fa2(M);fa2=fa2(M:-1:1);
det2=cumsum(hsn2(M:-1:1));det2=det2/det2(M);det2=det2(M:-1:1);
fa3=cumsum(hn3(M:-1:1));fa3=fa3/fa3(M);fa3=fa3(M:-1:1);
det3=cumsum(hsn3(M:-1:1));det3=det3/det3(M);det3=det3(M:-1:1);
fa4=cumsum(hn4(M:-1:1));fa4=fa4/fa4(M);fa4=fa4(M:-1:1);
det4=cumsum(hsn4(M:-1:1));det4=det4/det4(M);det4=det4(M:-1:1);

roc(1)=-sum(det1(2:M).*(fa1(2:M)-fa1(1:M-1)))-0.5;
roc(2)=-sum(det2(2:M).*(fa2(2:M)-fa2(1:M-1)))-0.5;
roc(3)=-sum(det3(2:M).*(fa3(2:M)-fa3(1:M-1)))-0.5;
roc(4)=-sum(det4(2:M).*(fa4(2:M)-fa4(1:M-1)))-0.5;

fprintf('ROC 1,2,3,4 : %f %f %f %f \n',roc(1),roc(2),roc(3),roc(4))

if verb > 0
    figure,plot(fa1,det1),grid,hold on,title('ROC curves')
    xlabel('false alarm probability'),ylabel('detection probability')
    plot(fa2,det2,'r'),plot(fa3,det3,'g'),plot(fa4,det4,'k'),plot(fa1,fa1,'m--')

    figure,loglog(fa1,det1),grid,hold on,title('ROC curves')
    xlabel('false alarm probability'),ylabel('detection probability')
    loglog(fa2,det2,'r'),loglog(fa3,det3,'g'),loglog(fa4,det4,'k'),loglog(fa1,fa1,'m--')
    
    figure,plot(fa1,det1-fa1),grid,hold on,title('reduced ROC curves')
    xlabel('false alarm probability'),ylabel('det-fa probability')
    plot(fa2,det2-fa2,'r'),plot(fa3,det3-fa3,'g'),plot(fa4,det4-fa4,'k')
    
    figure,plot(fa1,(det1-fa1)./fa1),grid,hold on,title('reduced ROC curves')
    xlabel('false alarm probability'),ylabel('(det-fa)/fa probability')
    plot(fa2,(det2-fa2)./fa2,'r'),plot(fa3,(det3-fa3)./fa3,'g'),plot(fa4,(det4-fa4)./fa4,'k')
    ylim([0 2*h0^2])
end