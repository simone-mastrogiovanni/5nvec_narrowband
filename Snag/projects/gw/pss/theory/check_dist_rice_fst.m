% check_dist_rice_fst

dx=0.01;
maxx=20;
xr=0:dx:maxx;
nxr=length(xr);
xc=0:dx:maxx^2;
nxc=length(xc);
xxc=sqrt(xc);
ampric=1;
ampchiq=2;

crice=sqrt(pi/2)/ampric;
price0=crice*ricepdf(xr*crice,0,1);
sum(xr.*price0)*dx
farice0=cumsum(price0(nxr:-1:1))*dx;
farice0=farice0(nxr:-1:1);

cchiq=4/ampchiq;
pchiq0=cchiq*chi2pdf(xc*cchiq,4);
sum(xc.*pchiq0)*dx
fachiq0=cumsum(pchiq0(nxc:-1:1))*dx;
fachiq0=fachiq0(nxc:-1:1);

figure,semilogy(xr,price0),hold on,semilogy(xxc,pchiq0,'r '),grid on
figure,semilogy(xr,farice0),hold on,semilogy(xxc,fachiq0,'r '),grid on