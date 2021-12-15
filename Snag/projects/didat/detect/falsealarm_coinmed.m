% falsealarm_coinmed
%
% computes false alarm for 2 antennas coincidence and mean

XX=50;
dd=0.01;
x=-XX:dd:XX;
n=length(x);
b=5;%b=1
p=0.02;p=1.0
y=p*exp(-abs(x/b))/(2*b)+(1-p)*exp(-x.^2/2)/sqrt(2*pi); % single antenna noise (bilat exp)
y=y/(sum(y)*dd);
y=gd(y);
y=edit_gd(y,'ini',-XX,'dx',dd,'capt','density single');
Y=pdf2cdf(y,-1,1);

YC=Y*Y;

ym=gd_convmed(y,y);
YM=pdf2cdf(ym,-1,1);

figure, semilogy(YC,YM,'r',Y,'g'),grid on

figure, semilogy(y,'g',ym,'r'),grid on

seg=2;

Ys=edit_gd(Y,'ini',ini_gd(Y)+seg,'capt',[capt_gd(Y) ' signal']);
YCs=edit_gd(YC,'ini',ini_gd(YC)+seg,'capt',[capt_gd(YC) ' signal']);
YMs=edit_gd(YM,'ini',ini_gd(YM)+seg,'capt',[capt_gd(YM) ' signal']);

figure, semilogy(YC,YM,'r',Y,'g'),grid on,hold on,semilogy(YCs,'--',YMs,'r--',Ys,'g--')

[rocc dc]=lin_rocfromfap(YC,[.5 1 2 4 8],'coincidences');
[rocm dm]=lin_rocfromfap(YM,[.5 1 2 4 8],' mean');
rocs=lin_rocfromfap(Y,[.5 1 2 4 8],' single');

mp_multiplot(rocc,'b',rocm,'r',rocs,'g')
mp_multiplot(dc,'b',dm,'r')
