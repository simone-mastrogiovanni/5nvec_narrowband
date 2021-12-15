function [ener enwav eps psi AAA BBB]=find_max_polar_eps(sour,ant,neps,npsi)
%FIND_MAX_POLAR  finds the most effective polarization
%
%   The power computation is done for an analytical signal (a factor 2 more)
%   that is what is simulated by sfdb09_band2sbl 
%
%   [ener eps psi]=find_max_polar(sour,ant,neps,npsi);
%
%  sour,ant   source and antenna structure
%  neps,npsi  number of epsilons and psis

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

t0=v2mjd([2007 9 1 0 0 0]);
sour=new_posfr(sour,t0);

del=sour.d*pi/180;
lam=ant.lat*pi/180;
a=ant.azim*pi/180;

a0=-(3/16)*(1+cos(2*del))*(1+cos(2*lam))*cos(2*a);
a1c=-(1/4)*sin(2*del)*sin(2*lam)*cos(2*a);
a1s=(1/2)*sin(2*del)*cos(lam)*sin(2*a);
a2c=-(1/16)*(3-cos(2*del))*(3-cos(2*lam))*cos(2*a);
a2s=(1/4)*(3-cos(2*del))*sin(lam)*sin(2*a);

b1c=-cos(del)*cos(lam)*sin(2*a);
b1s=-(1/2)*cos(del)*sin(2*lam)*cos(2*a);
b2c=-sin(del)*sin(lam)*sin(2*a);
b2s=-(1/4)*sin(del)*(3-cos(2*lam))*cos(2*a);

t=0:0.001:2*pi*10;
tt=t*100;
AA1=a1c*cos(t)+a1s*sin(t);
AA2=a2c*cos(2*t)+a2s*sin(2*t);
AAA=a0+AA1+AA2;
BB1=b1c*cos(t)+b1s*sin(t);
BB2=b2c*cos(2*t)+b2s*sin(2*t);
BBB=BB1+BB2;

deps=1/(neps-1);
dpsi=90/npsi;

eps=(0:neps-1)*deps;%eps(:)=1;
psi=(0:npsi-1)*dpsi;
fi=2*psi*pi/180;

ener=zeros(neps,npsi);
enwav=ener;
ctt=cos(tt);
stt=sin(tt);

for i = 1:neps
    ka=(eps(i)+sqrt(2-eps(i).^2))/2;
    kb=sqrt(1-ka^2);
    for j = 1:npsi
        HA=ka*cos(fi(j))*ctt-kb*sin(fi(j))*stt;
        HB=ka*sin(fi(j))*ctt+kb*cos(fi(j))*stt;
        enwav(i,j)=sum(HA.^2)+sum(HB.^2);
        h=AAA.*HA+BBB.*HB;
        ener(i,j)=2*mean(abs(h).^2); % the factor 2 for the analytical signal
    end
end

ener1=ener/max(max(ener));

figure,image(psi,eps,ener1,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
figure,image(psi,eps,ener,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
% figure,image(psi,eps,64*enwav/max(max(enwav))),colorbar

[h,x]=hist(ener(:),100);
h=cumsum(h)/sum(h);
i=find(h>0.05);
x05=x(i(1));
i=find(h>0.10);
x10=x(i(1));
i=find(h>0.50);
x50=x(i(1));
figure,hist(ener(:),100)
m=mean(ener(:));
s=std(ener(:));
disp(sprintf('mean,std: %f, %f',m,s))
disp(sprintf('percentile 5 10 50: %f, %f %f',x05,x10,x50))