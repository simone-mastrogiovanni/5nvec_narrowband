function [tfmap,p]=pss_peakmap(p)
%PSS_PEAKMAP   creates a power spectrum peak map (interlaced)
%
%     [tfmap,p]=pss_peakmap(p)
%
%   psspar  pss_par structure
%
%   tfmap   gd2 of the time-frequency map; the velocity components are in
%            deg and c %.
%
% If p.source.snr = -1  a coverage test peak map is created.
%
% Remember that MatLab stores matrices by columns, so it should be important to
% use the column index (the second) for the thing that changes more slowly,
% i.e. the time (but the matrix is sparse).
%
% Operation practical details:
%
%   frmin=p.band.bf1;   % DEF frmin
%
%   [fr1,a,d,v]=vdoppler(t,fr0,alpha,delta,long,lat,coord,0);
%   ind=ceil((fr1-frmin)/df+0.5);  %  DEF  ind



if p.source.snr < 0
    [tfmap,p]=pss_peakmaptest(p);
    return
end

rad2deg=180/pi;

time=p.data.tnum;
nspect=p.fft.N;
tspect=p.fft.tlen/86400;
df=p.fft.df;
frmin=p.band.bf1; % DEF frmin
thresh=p.tfmap.thr;
long=p.antenna.long;
lat=p.antenna.lat;
kfr0=p.band.errf0;
alpha=p.source.a;
delta=p.source.d;
fr0=p.source.f0;
snr=p.source.snr;
trend=p.source.df0;
every=p.fft.onev;
coord=p.hmap.type;

%tA=zeros(1,nspect);

nfr=ceil((p.band.bf2-p.band.bf1)/p.fft.df);

npeaktot=0;

t=time+(0:nspect-1)*tspect*every/2; % interlaced
[fr1,a,d,v]=vdoppler(t,fr0,alpha,delta,long,lat,coord,0);
ind=ceil((fr1-frmin)/df+0.5);  %  DEF  ind
sprintf('min, max d (deg) : %f , %f',min(d)*rad2deg,max(d)*rad2deg)

for i = 1:nspect
   y=(randn(1,nfr).^2+randn(1,nfr).^2)/2;
   %y(ind)=(sqrt(y(ind))+sqrt(2*snr))^2;
   y(ind(i))=((randn(1,1)+sqrt(2*snr)).^2+randn(1,1).^2)/2;
   y1=rota(y,1);
   y2=rota(y,-1);
   y1=ceil(sign(y-y1)/2);
   y2=ceil(sign(y-y2)/2+0.1);
   y1=y1.*y2;
   y=y.*y1;
   y2=ceil(sign(y-thresh)/2);
   y=y.*y2;
   npeak=sum(y2);
   [i1,j1,s1]=find(y);
   i2(npeaktot+1:npeaktot+npeak)=j1;
   j2(npeaktot+1:npeaktot+npeak)=i;
   s2(npeaktot+1:npeaktot+npeak)=s1;
   npeaktot=npeaktot+npeak;
end

p.tfmap.npeaktot=npeaktot; npeaktot

A=sparse(i2,j2,s2,nfr,nspect);
figure;
spy(A);

tfmap=gd2(A');
dx=p.fft.tlen*p.fft.onev/(2*86400); % Interlaced !
dx2=p.fft.df;ini2=p.band.bf1;
capt=p.tfmap.capt;
tfmap=edit_gd2(tfmap,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);

tfmap=set_gd2_v(tfmap,a*rad2deg,d*rad2deg,v);