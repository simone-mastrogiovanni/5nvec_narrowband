% pareto_coinmed

XX=50;
dd=0.01;
x=-XX:dd:XX;
n=length(x);
b=5;%b=1
p=0.01;p=0.0
y=p*exp(-abs(x/b))/(2*b)+(1-p)*exp(-x.^2/2)/sqrt(2*pi); % single antenna noise (bilat exp)
y=y/(sum(y)*dd);
y=gd(y);
y=edit_gd(y,'ini',-XX,'dx',dd,'capt','density single');
Y=pdf2cdf(y,-1,1);

YC=Y*Y;

ym=gd_convmed(y,y);
YM=pdf2cdf(ym,-1,1);

% figure, semilogy(YC,Y,YM),grid on
% 
% figure, semilogy(y,'g',ym,'r'),grid on

% YM1=y_gd(YM);
% YC1=y_gd(YC);
% YM2=YM1(1:2:length(YM1));
% figure,plot(x,YM2./YC1),grid on

seg=5;
shift=round(seg/dd);
ll=length(YC1);
xx=x(shift+1:ll);
YCa=YC1(shift+1:ll);
YCb=YC1(1:ll-shift);
% figure,semilogy(xx,YCb-YCa),hold on

YMa=YM2(shift+1:ll);
YMb=YM2(1:ll-shift);
% semilogy(xx,YMb-YMa,'r'),grid on

% figure,semilogy(xx,YMa),hold on,semilogy(xx,YMb,'r'),grid on,semilogy(xx,YMb./YMa,'g')
% figure,semilogy(xx,YCa),hold on,semilogy(xx,YCb,'r'),grid on,semilogy(xx,YCb./YCa,'g')
% 
% figure,plot(YCa,YCb),hold on,plot(YMa,YMb,'r'),grid on

pdf1=powlaw_dist(0:dd:20,2,.1,'pareto',1);
pdf2=powlaw_dist(0:dd:20,2,.5,'pareto',1);

c1=gd_conv(YC,pdf1);
c2=gd_conv(YC,pdf2);
m1=gd_conv(YM,pdf1);
m2=gd_conv(YM,pdf2);

figure,semilogy(c1,m1,'r'),grid on

% p1=y_gd(pdf1);
% p2=y_gd(pdf2);
% p0=p1*0;p0(1)=1;
% 
% c0=conv(YC1,p0);
% m0=conv(YM1,p0);
% c1=conv(YC1,p1)*dd;
% m1=conv(YM1,p1)*dd;size(YC1),size(c0),size(c1),size(x),size(YM1),size(m0),size(m1),
% c2=conv(YC1,p2)*dd;
% m2=conv(YM1,p2)*dd;
% 
% figure,semilogy(x,c1(1:length(x))),hold on,semilogy(x,m1(1:length(x)),'r'),semilogy(x,m0(1:length(x)),'g'),grid on
% semilogy(x,c2(1:length(x)),'--'),hold on,semilogy(x,m2(1:length(x)),'r--'),semilogy(x,m0(1:length(x)),'g--'),grid on
% 
% figure,loglog(c0,c1),hold on,loglog(m0,m1,'r'),grid on
% loglog(c0,c2,'--'),hold on,loglog(m0,m2,'r--'),grid on