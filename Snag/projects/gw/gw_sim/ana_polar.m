function s=ana_polar(sour,ant,N)
%ANA_POLAR  analizes spectral splitting due to polarization using gw_polariz
%
%    N    number of epsilon
%
% produces sidereal band contents

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=16384*8;
nsid=1000;
nper=10;
fr_gw=nsid/nper;
fr_sid=1;

dt=1/nsid;
df=1/(dt*n);

frbands=floor((n/nsid)*(fr_gw-(2.5-(0:5))*fr_sid));

if N < 2 
    N=2;
end
deps=1/(N-1);
bands=zeros(N,5);

for j = 1:N
    sour.eps=(j-1)*deps;
	g=gw_polariz(sour,ant,n,nsid,nper);
	s=gd_pows(g);
	y=y_gd(s);
	
	for i=1:5
        bands(j,i)=sum(y(frbands(i):frbands(i+1)))*df;
	end
	
	bandtot=sum(bands(j,:));
	bands(j,:)=bands(j,:)/bandtot;
    w2(j)=sum(bands(j,:).*bands(j,:));
    pN(j)=2./w2(j);
end

bands 
w2
pN
% figure,plot(bands)
% figure,plot(bands')

