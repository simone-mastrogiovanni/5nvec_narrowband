% driver_campo_daxs

lcell=0.5;

xd=zeros(3,20);
r=0:200;
phi=30;
theta=40;

xd=rotate_v3(r,phi,theta);
x=sqrt(xd(1,:).^2+xd(2,:).^2+xd(3,:).^2);
yyy=1./x.^2;

% sfera

raggio=10;
nsf=round(raggio*2/lcell);
xs=griglia_circ(nsf,lcell);
show_grid_3D(xs);title('sorgente sferica')

[yy y]=campo_daxs(xs,xd);

figure;plot(x,y);hold on,plot(x,y,'r.');grid on
title('sorgente sferica')
figure;semilogy(x,y);hold on;semilogy(x,y,'r.'),grid on
title('sorgente sferica')
figure;loglog(x,y);hold on,loglog(x,y,'r.');grid on
title('sorgente sferica')
figure;loglog(x,yy);hold on,loglog(x,yyy,'g');grid on
title('sorgente sferica')

% parallelepipedo

l1=20;
l2=15;
l3=10;
n1=round(l1/lcell);
n2=round(l2/lcell);
n3=round(l3/lcell);
xp=griglia_ret(n1,n2,n3,lcell);
show_grid_3D(xp);title('sorgente a mattone')


[yy1 y1]=campo_daxs(xp,xd);

figure;plot(x,y1);hold on,plot(x,y1,'r.');grid on
title('sorgente a mattone')
figure;semilogy(x,y1);hold on;semilogy(x,y1,'r.'),grid on
title('sorgente a mattone')
figure;loglog(x,y1);hold on,loglog(x,y1,'r.');grid on
title('sorgente a mattone')
figure;loglog(x,yy1);hold on,loglog(x,yyy,'g');grid on
title('sorgente a mattone')

% due puntiformi

d=10;

x2p=zeros(3,2);
x2p(1,1)=d/2;
x2p(1,2)=-d/2;
show_grid_3D(x2p);title('due sorgenti puntiformi')

[yy2 y2]=campo_daxs(x2p,xd);

figure;plot(x,y2);hold on,plot(x,y2,'r.');grid on
title('due sorgenti puntiformi')
figure;semilogy(x,y2);hold on;semilogy(x,y2,'r.'),grid on
title('due sorgenti puntiformi')
figure;loglog(x,y2);hold on,loglog(x,y2,'r.');grid on
title('due sorgenti puntiformi')
figure;loglog(x,yy2);hold on,loglog(x,yyy,'g.');grid on
title('due sorgenti puntiformi')