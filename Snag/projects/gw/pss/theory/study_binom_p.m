% study_binom_p binomial prob, in case of peak and all

N=12;
dsig=0.1
dthresh=0.1;

y=peak_pot(dsig,20,dthresh);
y1=spec_rcdf(dsig,20,dthresh);
yy1=y1;
diffy=y1;
diffy1=y1;
dify=y1;
dify1=y1;

for i=1:N
    sig=(i-1)*dsig;
    xsig(i)=sig;
    [y(i,:),x]=peak_pot(sig,20,dthresh);
    y1(i,:)=spec_rcdf(sig,20,dthresh);
%     yy1(i,:)=exp(-x*exp(-sig));
%     appo=y(i,:);
%     diffy(i,1:length(x)-1)=diff(appo);
%     appo=y1(i,:);
%     diffy1(i,1:length(x)-1)=diff(appo);
end

figure
semilogy(x,y),grid on
figure
semilogy(x,y1),grid on
% figure
% semilogy(x,yy1),grid on

figure
plot(x,y),grid on
figure
plot(x,y1),grid on

% figure
% plot(x,diffy),grid on
% figure
% plot(x,diffy1),grid on

DIV=5;
DIV1=4;

n=length(x)
figure
plot(xsig,y(:,1:DIV:(n/DIV1))),grid on
% figure
% semilogy(xsig,y(:,1:DIV:(n/DIV1))),grid on

figure
plot(xsig,y1(:,1:DIV:(n/DIV1))),grid on
% figure
% semilogy(xsig,y1(:,1:DIV:(n/DIV1))),grid on

for i = 1:DIV:(n/DIV1)
    appo=y(:,i);
    dify(1:length(appo)-1,i)=diff(appo)/dsig;
    appo=y1(:,i);
    dify1(1:length(appo)-1,i)=diff(appo)/dsig;
end

figure
plot(dify(:,1:DIV:(n/DIV1))),grid on
figure
plot(dify1(:,1:DIV:(n/DIV1))),grid on


for i = 1:N
    z(i,:)=y(i,:)./y(1,:);
    z1(i,:)=y1(i,:)./y1(1,:);
    z(i,:)=((z(i,:)-1)./x)/xsig(i);
    z1(i,:)=((z1(i,:)-1)./x)/xsig(i);
end

figure
plot(xsig,z(:,1:DIV:(n/DIV1))),grid on
% figure
% semilogy(xsig,z(:,1:DIV:(n/DIV1))),grid on

figure
plot(xsig,z1(:,1:DIV:(n/DIV1))),grid on
% figure
% semilogy(xsig,z1(:,1:DIV:(n/DIV1))),grid on

figure
plot(x,z),grid on
% figure
% semilogy(x,z),grid on
% figure
% loglog(x,z),grid on

figure
plot(x,z1),grid on
% figure
% semilogy(x,z1),grid on
% figure
% loglog(x,z1),grid on