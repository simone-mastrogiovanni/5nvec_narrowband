function [bands,varb]=ana_polar_spfilt(sour,ant,eps,psi,first)
%ANA_POLAR_SPFILT  analizes spectral splitting due to polarization using gw_polariz
%
%    eps    [min,max,n] eps
%    psi    [min,max,n] psi
%    first  1 or 2 depending if eps or psi
%
% produces sidereal band contents

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('first')
    first=1;
end

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

j=0;
nb=eps(3)*psi(3);
bands=zeros(nb,5);

switch first
    case 1
		for j1 = 1:eps(3)
            sour.eps=eps(1)+(j1-1)*deps;
            for j2 = 1:psi(3)
                sour.psi=psi(1)+(j2-1)*dpsi;
%                 sour.fi=2*sour.psi;
                g=gw_polariz(sour,ant,n,nsid,nper);
                s=gd_pows(g);
                y=y_gd(s);
                j=j+1;

                for i=1:5
                    bands(j,i)=sum(y(frbands(i):frbands(i+1)))*df;
                end

                bandtot=sum(bands(j,:));
                bands(j,:)=bands(j,:)/bandtot;
                w2(j)=sum(bands(j,:).*bands(j,:));
%                 for j3 = 1:fi(3)
%                     sour.fi=fi(1)+(j3-1)*dfi;
% 					g=gw_polariz(sour,ant,n,nsid,nper);
% 					s=gd_pows(g);
% 					y=y_gd(s);
%                     j=j+1;
% 					
% 					for i=1:5
%                         bands(j,i)=sum(y(frbands(i):frbands(i+1)))*df;
% 					end
% 					
% 					bandtot=sum(bands(j,:));
% 					bands(j,:)=bands(j,:)/bandtot;
%                     w2(j)=sum(bands(j,:).*bands(j,:));
%                     pN(j)=2./w2(j);
%                 end
            end
		end
    case 2
		for j1 = 1:psi(3)
            sour.psi=psi(1)+(j1-1)*dpsi;
%             sour.fi=2*sour.psi;
            for j3 = 1:eps(3)
                sour.eps=eps(1)+(j3-1)*deps;
                g=gw_polariz(sour,ant,n,nsid,nper);
                s=gd_pows(g);
                y=y_gd(s);
                j=j+1;

                for i=1:5
                    bands(j,i)=sum(y(frbands(i):frbands(i+1)))*df;
                end

                bandtot=sum(bands(j,:));
                bands(j,:)=bands(j,:)/bandtot;
                w2(j)=sum(bands(j,:).*bands(j,:));
                pN(j)=2./w2(j);
            end
		end
%     case 3
% 		for j1 = 1:fi(3)
%             sour.fi=fi(1)+(j1-1)*dfi;
%             for j2 = 1:eps(3)
%                 sour.eps=eps(1)+(j2-1)*deps;
%                 for j3 = 1:psi(3)
%                     sour.psi=psi(1)+(j3-1)*dpsi;
% 					g=gw_polariz(sour,ant,n,nsid,nper);
% 					s=gd_pows(g);
% 					y=y_gd(s);
%                     j=j+1;
% 					
% 					for i=1:5
%                         bands(j,i)=sum(y(frbands(i):frbands(i+1)))*df;
% 					end
% 					
% 					bandtot=sum(bands(j,:));
% 					bands(j,:)=bands(j,:)/bandtot;
%                     w2(j)=sum(bands(j,:).*bands(j,:));
%                     pN(j)=2./w2(j);
%                 end
%             end
% 		end
end

varb(1:nb-1)=0;

for j = 2:nb
    varb(j-1)=1-(bands(j,:).*bands(j-1,:))/(bands(j,:).*bands(j,:));
end

mean(varb),std(varb)

% bands
% w2
% pN
figure,plot(bands)
figure,plot(varb)

