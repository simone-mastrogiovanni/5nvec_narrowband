function [x,b,index,nlon]=pss_optmap(ND,reslam)
% PSS_OPTMAP  computes the optimal choice for the sky map
%
%      [x,b,index,nlon]=pss_optmap(ND)
%
%    ND       Doppler number (number of frequency bins in the *full* Doppler band)
%    reslam   lambda resolution (default 1; > 1 higher resolution)
%
%    x(n,5)   point coordinates with neighbours [l b lstep b- b+]
%    b        ecliptical latitudes
%    index    index for new beta
%    nlon     number of longitudes for each lat
%
%  pss_opt_map       all sky
%  pss_opt_map_spot  for directed "square" spot
%  pss_opt_map_ref   for follow-up

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('reslam','var')
    reslam=1;
end

% ND1=ND*100;
% bet=(ND1:-1:1)*pi/(2*ND1);
% delbet=1./(ND*sin(bet));
% bet=cumsum(delbet)/100;

k=1+0.01/ND;
beterr=1;
bet=-.999;
ii=0;

while beterr > -bet
    ii=ii+1;
    beterr=-bet;
    bet=pi/2;
    i=1;
    k=k-0.01/ND;
    while bet > 0
        i=i+1;
        bet=bet-k/(ND*sin(bet));
    end
end

i=i-1;
n=i*2-1;
% ii,n,beterr
b=zeros(n,1);
index=b;
nlon=b;

b(1)=pi/2;
b(i)=0;
b(n)=-pi/2;

for j = 2:i-1
    b(j)=b(j-1)-k/(ND*sin(b(j-1)));
    b(n-j+1)=-b(j);
end

x=zeros(n*n*7,5);
x(1,1)=180;
x(1,2)=90;
x(1,3)=360;
kk=1;
index(1)=kk;

for j = 2:n-1
    index(j)=kk+1;
    nl=ceil(reslam*2*pi*(ND*cos(b(j))));
    dl=360/nl;
    fas=(j-floor(j/2)*2)*dl/2;
    for jj = 0:nl-1
        kk=kk+1;
        x(kk,1)=fas+jj*dl;
        x(kk,2)=b(j)*180/pi;
        x(kk,3)=dl;
        x(kk,4)=b(j-1)*180/pi;
        x(kk,5)=b(j+1)*180/pi;
    end
end

x(1,4)=90;
x(1,5)=x(2,2);
kk=kk+1;
index(n)=kk;
nlon(1:n-1)=diff(index);
nlon(n)=1;
x(kk,1)=180;
x(kk,2)=-90;
x(kk,3)=360;
x(kk,4)=x(kk-1,2);
x(kk,5)=-90;
x=x(1:kk,:);
b=b*180/pi;

gain=2*(pi*ND)^2/kk;