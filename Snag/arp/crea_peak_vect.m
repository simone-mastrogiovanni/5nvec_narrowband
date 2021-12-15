function y=crea_peak_vect(nfr,thr,snr,ind)
%CREA_PEAK_VECT   creates a spectral peak vector
%
%    y=crea_peak_vect(nfr,thr,sig)

npeaktot=0;

y=(randn(1,nfr).^2+randn(1,nfr).^2)/2;
y(ind)=((randn(1,1)+sqrt(2*snr)).^2+randn(1,1).^2)/2;
y1=rota(y,1);
y2=rota(y,-1);
y1=ceil(sign(y-y1)/2);
y2=ceil(sign(y-y2)/2);
y1=y1.*y2;
y=y.*y1;
y2=ceil(sign(y-thr)/2);
y=y.*y2;
npeak=sum(y2);
[i1,j1,s1]=find(y);
i2(npeaktot+1:npeaktot+npeak)=j1;
j2(npeaktot+1:npeaktot+npeak)=i;
s2(npeaktot+1:npeaktot+npeak)=s1;
npeaktot=npeaktot+npeak;
