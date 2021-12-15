function [lines orig]=ana_polar_lines(sour,ant,eps,psi)
%ANA_POLAR_SPFILT  analizes spectral splitting due to polarization using gw_polariz
%
%    eps    [min,max,n] eps
%    psi    [min,max,n] psi
%    first  1 or 2 depending if eps or psi 
%
% produces sidereal components

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome 

if eps(3) > 1
    deps=(eps(2)-eps(1))/(eps(3)-1);
else
    deps=0;
end
if psi(3) > 1
    dpsi=(psi(2)-psi(1))/(psi(3)-1);
else
    dpsi=0;
end

n=16384*8;
nsid=1000;
nper=10;
fr_gw=nsid/nper;
fr_sid=1;

dt=1/nsid;
df=1/(dt*n);

frbands=floor((n/nsid)*(fr_gw-(2.5-(0:5))*fr_sid)); % frbands
frlines=(fr_gw+[-2*fr_sid -fr_sid 0 fr_sid fr_sid*2]);%*n/nsid-1
om=frlines*2*pi;
t=(0:n-1)*dt;
t=t';

jj=0;
nb=eps(3)*psi(3);
lines=zeros(nb,5);
orig=zeros(nb,3);


for j1 = 1:eps(3)
    sour.eps=eps(1)+(j1-1)*deps;
    for j2 = 1:psi(3)
        sour.psi=psi(1)+(j2-1)*dpsi;
        sour.fi=2*sour.psi;
        g=gw_polariz(sour,ant,n,nsid,nper);
        y=y_gd(g);
        jj=jj+1;
        orig(jj,:)=[sour.eps,sour.psi,sour.fi];
        for ii = 1:5
            lines(jj,ii)=sum(y.*exp(j*om(ii).*t));
        end
        lines(jj,:)=lines(jj,:)/sqrt
%         for j3 = 1:fi(3)
%             sour.fi=fi(1)+(j3-1)*dfi;
%             g=gw_polariz(sour,ant,n,nsid,nper);
%             y=y_gd(g);
%             jj=jj+1;
%             orig(jj,:)=[sour.eps,sour.psi,sour.fi];
%             for ii = 1:5
%                 lines(jj,ii)=sum(y.*exp(j*om(ii).*t));
%             end
%             lines(jj,:)=lines(jj,:)/sqrt(sum(abs(lines(jj,:)).^2));
%         end
    end
end

% bands
% w2
% pN
% figure,plot(bands)

