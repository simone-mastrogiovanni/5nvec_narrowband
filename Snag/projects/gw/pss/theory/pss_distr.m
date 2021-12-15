% basic distributions

N=3000;
N4=N^(1/4);
mur=N
sigr=sqrt(mur)

xr=1:3*mur;

yr=2*chi2pdf(2*xr,2*mur);
yg=exp(-(xr-mur).^2/(2*sigr^2))/(sqrt(2*pi)*sigr);
nrad=length(yr);

figure
plot(xr,yr),hold on, grid on
plot(xr,yg,'r')

figure
semilogy(xr,yr),hold on,grid on
semilogy(xr,yg,'r')

p=1/12;
mu=N*p
sig=sqrt(N*p*(1-p))

x=1:3*mu;

yh=binopdf(x,N,p);
ygh=exp(-(x-mu).^2/(2*sig^2))/(sqrt(2*pi)*sig);

figure
plot(x,yh),hold on, grid on
plot(x,ygh,'r')

figure
semilogy(x,yh),hold on,grid on
semilogy(x,ygh,'r')

% reverse cumulative

Rcum_r(nrad:-1:1)=cumsum(yr(nrad:-1:1));
y=(xr-mur)/sigr;
ExpRcum=y*0;

for i = 1:nrad
    if y(i) < 0
        ExpRcum(i)=1;
    else
        ExpRcum(i)=exp(-y(i)*sqrt(N));
    end
end

Ncand_opt=6e31;
Ncand_hier=2.25e16;
figure
% semilogy(y,Ncand_hier*Rcum_r),grid on,hold on
% semilogy(y,Ncand_opt*ExpRcum,'r')
semilogy(y,Rcum_r),grid on,hold on
semilogy(y,ExpRcum,'r')

% normalized distributions

dx=0.01;
x=(0:dx:100);
sig=sqrt(N)
Ex=exp(-x*sig); % optimal method distribution

gau=exp(-((x-1).^2)./(2))/(sqrt(2*pi));
ngau=length(gau)
Gau(ngau:-1:1)=cumsum(gau(ngau:-1:1))*dx;

figure,length(x),length(Gau)
semilogy(x*sig,Ex),grid on,hold on
semilogy(x*sig,Gau,'r')

% normalized distributions linear in h

dx=0.01;
x=(0:dx:10);
xx=x.^2;
sig=sqrt(N)
Ex=exp(-xx*sig); % optimal method distribution

gau=exp(-((xx-1).^2)./(2))/(sqrt(2*pi));
ngau=length(gau)
igau=gau(ngau:-1:1);
Gau=cumsum(igau)*dx;
Gau=Gau(ngau:-1:1);

figure
semilogy(x*sqrt(sig),Ex),grid on,hold on
semilogy(x*sqrt(sig),Gau,'r')
