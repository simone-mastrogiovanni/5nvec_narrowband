function [lines orig]=fit_polar_lines(sour,ant,eps,psi)
%FIT_POLAR_LINES  analizes spectral splitting due to polarization using gw_polariz
%
%    sour,ant  structures
%    eps       [min,max,n] eps
%    psi       [min,max,n] psi
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

n=16384;
nsid=1000;
nper=10;
fr_gw=nsid/nper;
fr_sid=1;

dt=1/nsid;
df=1/(dt*n);

frbands=floor((n/nsid)*(fr_gw-(2.5-(0:5))*fr_sid)); % frbands
frlines=(fr_gw+[-fr_sid -fr_sid/2 0 fr_sid/2 fr_sid]);%*n/nsid-1
par=frlines;
om=frlines*2*pi;
t=(0:n-1)*dt;
t=t';

jj=0;
nb=eps(3)*psi(3)*fi(3);
lines=zeros(nb,5);
orig=zeros(nb,3);


for j1 = 1:eps(3)
    sour.eps=eps(1)+(j1-1)*deps;
    for j2 = 1:psi(3)
        sour.psi=psi(1)+(j2-1)*dpsi;
%         sour.fi=2*sour.psi;
        g=gw_polariz(sour,ant,n,nsid,nper);
        [a,covar,F,res,chiq,ndof,err,errel]=gen_lin_fit(g,0,1,2,par,1);
        jj=jj+1
        orig(jj,:)=[sour.eps,sour.psi];
        for ii = 1:5
            iii=2*ii-1;
            lines(jj,ii)=a(iii)+1i*a(iii+1);
        end
        lines(jj,:)=lines(jj,:)/sqrt(sum(abs(lines(jj,:)).^2));
%         for j3 = 1:fi(3)
%             sour.fi=fi(1)+(j3-1)*dfi;
%             g=gw_polariz(sour,ant,n,nsid,nper);
%             [a,covar,F,res,chiq,ndof,err,errel]=gen_lin_fit(g,0,1,2,par,1);
%             jj=jj+1
%             orig(jj,:)=[sour.eps,sour.psi,sour.fi];
%             for ii = 1:5
%                 iii=2*ii-1;
%                 lines(jj,ii)=a(iii)+j*a(iii+1);
%             end
%             lines(jj,:)=lines(jj,:)/sqrt(sum(abs(lines(jj,:)).^2));
%         end
    end
end

% bands
% w2
% pN
% figure,plot(bands)

