function [x,b]=pss_optmap_1(ND,reslam)
% PSS_OPTMAP  computes the optimal choice for the sky map
%
%      [x,b]=pss_optmap_1(ND,reslam) or [x,b]=pss_optmap_1(ND)
%
%    ND       Doppler number (number of frequency bins in the Doppler band)
%    reslam   lambda resolution (default 1; > 1 higher resolution)
%
%    x(n,2)   point coordinates
%    b        ecliptical latitudes

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('reslam','var')
    reslam=1;
end

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
ii,n,beterr
b=zeros(n,1);

b(1)=pi/2;
b(i)=0;
b(n)=-pi/2;

for j = 2:i-1
    b(j)=b(j-1)-k/(ND*sin(b(j-1)));
    b(n-j+1)=-b(j);
end

x=zeros(n*n*7,2);
x(1,1)=180;
x(1,2)=90;
kk=1;

for j = 2:n-1
    nl=ceil(reslam*2*pi*(ND*cos(b(j))));
    dl=360/nl;
    fas=(j-floor(j/2)*2)*dl/2;
    for jj = 0:nl-1
        kk=kk+1;
        x(kk,1)=fas+jj*dl;
        x(kk,2)=b(j)*180/pi;
    end
end

kk=kk+1
x(kk,1)=180;
x(kk,2)=-90;
x=x(1:kk,:);

gain=2*(pi*ND)^2/kk