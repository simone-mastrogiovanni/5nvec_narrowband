% check_dist_chiq_2_4

ampsig=0;
ampsig2=ampsig^2;
dx=0.01;
maxx=round(20+ampsig2*3);
x=0:dx:maxx;
nx=length(x);

pchiq20=ncx2pdf(x,2,ampsig2);
sum(x.*pchiq20)*dx
fachiq20=cumsum(pchiq20(nx:-1:1))*dx;
fachiq20=fachiq20(nx:-1:1);

pchiq40=ncx2pdf(x,4,ampsig2);
sum(x.*pchiq40)*dx
fachiq40=cumsum(pchiq40(nx:-1:1))*dx;
fachiq40=fachiq40(nx:-1:1);

figure,semilogy(x,pchiq20),hold on,semilogy(x,pchiq40,'r '),grid on
figure,semilogy(x,fachiq20),hold on,semilogy(x,fachiq40,'r '),grid on