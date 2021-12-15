% study_spec_prob study of the spectral amplitudes probability over a threshold

N=11;
dsig=0.1;
dthresh=0.001;
xmax=20;

x=dthresh:dthresh:xmax;
xsig=0:dsig:dsig*(N-1);
y=zeros(N,length(x));
y1=zeros(N,floor(xmax/0.5));

for i=1:N
    sig=(i-1)*dsig;
    xsig(i)=sig;
    y(i,:)=spec_prob(sig,xmax,dthresh);
    y1(i,:)=spec_prob(sig,xmax,0.5);
    sigleg{i}=sprintf(' %3f',sig);
end

figure
semilogy(x,y),grid on
xlabel('Threshold')
ylabel('Spec Probability')
legend(sigleg)
    
figure
plot(x,y),grid on
xlabel('Threshold')
ylabel('Spec Probability')
legend(sigleg)

figure,plot(xsig,y1(:,1:10));grid on
xlabel('\lambda')
ylabel('Spec Probability')

d=diff(y1)/dsig;
figure,plot(xsig(1:length(xsig)-1),d(:,3:5)),grid on
xlabel('\lambda')
ylabel('Derivate of Spec Probability')
title('Threshold 1.5, 2, 2.5')