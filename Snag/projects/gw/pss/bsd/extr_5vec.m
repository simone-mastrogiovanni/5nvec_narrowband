function [v,phout]=extr_5vec(gin,fr0,n,phcorr)
% extracts n 5 vec from n interlaced pieces of a bsd gd
%
%       v=extr_5vec(gin,fr,n)
%
%   gin      input gd
%   fr0      central frequency
%   n        number of interlaced pieces
%   phcorr   1 0, yes or not phase correction

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('phcorr','var')
    phcorr=0;
end

FS=1/86164.09053083288;
Dfr=(-2:2)*FS;
fr=fr0+Dfr;

y=y_gd(gin);
N=n_gd(gin);
dt=dx_gd(gin);
cont=cont_gd(gin);
st=gmst(cont.t0)*3600;

v=zeros(5,n);

n1=floor(N/(n+1));
n2=n1*2;
Tlong=n2*dt;

nn=(0:n-1)*n1+1;
rit0=0;

for i = 1:n
    for j = 1:5
        Dt=rit0*dt+st;
        phout(j,i)=360*mod(Dt*Dfr(j),1);
        v(j,i)=sum(y(nn(i):nn(i)+n2-1).*exp(-1j*2*pi*fr(j)*(0:n2-1)'*dt).*exp(-1j*2*pi*fr(j)*phcorr*Dt))*dt/Tlong;
%         w(j,i)=sum(real(y(nn(i):nn(i)+n2-1)).*exp(-1j*2*pi*fr(j)*(0:n2-1)'*dt))*dt/Tlong;
    end
    rit0=rit0+n1;
end
