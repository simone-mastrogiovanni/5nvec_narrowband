function [x,b]=pss_optmap_pia(ND)
% PSS_OPTMAP  computes the optimal choice for the sky map
%
%      [x,b]=pss_optmap(ND)
%
%    ND       Doppler number (number of frequency bins in the Doppler band)
%
%    x(n,2)   point coordinates
%    b        ecliptical latitudes

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

db0=1/ND;
ddb=0.01*db0/ND;

for j = 1:100
    db0a=db0-j*ddb;
    clear b
    b(1)=pi/2;
    bb=b(1);
    i=1;
    while bb > 0
        i=i+1;
        b(i)=b(i-1)-db0a/sin(b(i-1));
        bb=b(i);
    end
    y(j)=min(b(1:i-1));
end

[ai,bi]=min(y);
c=(b(i-2)-b(i-1));

db0a=db0-bi*ddb;

b(1)=pi/2;
bb=b(1);
i=1;
while bb > 0
    i=i+1;
    b(i)=b(i-1)-db0a/sin(b(i-1));
    bb=b(i);
end

nb=i-2;
b=b(1:nb);

dlam0=1/ND;
n=ceil(2*pi/dlam0);
dlam=2*pi/n;
x(1:n,1)=(0:n-1)*dlam;
x(1:n,2)=0;
N=n;

x(n+1,1)=0;
x(n+1,2)=pi/2;
x(n+2,1)=0;
x(n+2,2)=-pi/2;
N=N+2;

for i = 2:nb
    dlam1=dlam0/cos(b(i));
    n=ceil(2*pi/dlam1);
    dlam=2*pi/n;
    ii=i-floor(i/2)*2;
    x(N+1:N+n,1)=(0:n-1)*dlam+dlam*ii/2;
    x(N+1:N+n,2)=b(i);
    N=N+n;
    x(N+1:N+n,1)=(0:n-1)*dlam+dlam*ii/2;
    x(N+1:N+n,2)=-b(i);
    N=N+n;
end

x=x*180/pi;


N
gain=2*(pi*ND)^2/N