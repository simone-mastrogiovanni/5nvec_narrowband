% study_fi study of the Fi function

N=11;
dsig=0.1;
dthresh=0.1;
xmax=20;

x=dthresh:dthresh:xmax;
xsig=0:dsig:dsig*(N-1);
y=zeros(N,length(x));
y1=zeros(N,floor(xmax/0.5));

for i=1:N
    sig=(i-1)*dsig;
    xsig(i)=sig;
    y(i,:)=peak_fi(sig,xmax,dthresh);
    y1(i,:)=peak_fi(sig,xmax,0.5);
    sigleg{i}=sprintf(' %3f',sig);
end

figure
semilogy(x,y),grid on
xlabel('Threshold')
ylabel('\Phi')
legend(sigleg)
    

figure
plot(x,y),grid on
xlabel('Threshold')
ylabel('\Phi')
legend(sigleg)

xm=max(y');
figure,plot(xsig,xm,'+'),grid on
xlabel('\lambda')
ylabel('Max \Phi')

figure,plot(xsig,y1(:,1:10));grid on
xlabel('\lambda')
ylabel('\Phi')