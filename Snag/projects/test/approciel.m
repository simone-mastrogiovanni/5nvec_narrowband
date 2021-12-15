% approciel

lam=42;
bet=80;
dlam=-2;
dbet=2;

lam1=lam*pi/180;
bet1=bet*pi/180;
dlam1=dlam*pi/180;
dbet1=dbet*pi/180;

om0=pi/20;
t=0:100;

f=cos(bet1+dbet1)*sin(om0*t+lam1+dlam1)-cos(bet1)*sin(om0*t+lam1);

f1=cos(bet1)*cos(om0*t+lam1+dlam1)*sin(dlam1)-sin(bet1)*sin(om0*t+lam1)*sin(dbet1);

figure,plot(f),hold on,plot(f1,'r.'),grid on

r=f./(cos(bet1)*sin(om0*t+lam1)+eps);
r1=f1./(cos(bet1)*sin(om0*t+lam1)+eps);

figure,plot(r),hold on,plot(r1,'r.'),grid on

d=(cos(bet1)*sin(om0*t+lam1)+eps)-f;
d1=(cos(bet1)*sin(om0*t+lam1)+eps)-f1;

figure,plot(d),hold on,plot(d1,'r.'),grid on