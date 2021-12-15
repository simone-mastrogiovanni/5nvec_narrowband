function [ener plus fi AAA BBB]=find_max_polar_pp(sour,ant,nplus,nfi)
%FIND_MAX_POLAR  finds the most effective polarization
%
%   [ener plus cross]=find_max_polar(sour,ant,nplus,nfi);
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

dplus=1/(nplus+1);
dfi=180/nfi;

plus=(0:nplus-1)*dplus;
fi=(0:nfi-1)*dfi;
fi1=fi*pi/180;

ener=zeros(nplus,nfi);

for i = 1:nplus
    kal=plus(i);
    kar=sqrt(1-kal^2);
    for j = 1:nfi
        h=(kal*AAA+kar*exp(1j*fi1(j))*BBB).*exp(1j*tt);
%         h=kal*AAA.*cos(tt)+kar*BBB.*(cos(tt)*cos(fi1(j))-sin(tt)*sin(fi1(j)));
        ener(i,j)=sum(real(h).^2);
    end
end

ener1=ener-min(min(ener));
ener=ener/max(max(ener));
ener1=ener1/max(max(ener1));

figure,image(fi,plus,64*ener1),colorbar
figure,image(fi,plus,64*ener),colorbar