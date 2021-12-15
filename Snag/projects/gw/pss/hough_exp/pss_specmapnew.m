function [tfps,p]=pss_specmapnew(p)
%PSS_SPECMAPNEW   creates a power spectrum map (interlaced)
%
%        [tfps,p]=pss_specmapnew(p)

time=p.data.tnum;
nspect=p.fft.N;
tspect=p.fft.tlen/86400;
df=p.fft.df;
frmin=p.band.bf1;
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

%df=1/(tspect*86400);
%fr00=frmin*1.000106; % 0.000106 > v/c
%nfr=ceil((fr00-frmin)*2/df);
%fr00=frmin+df*nfr/2;
%fr0=fr00+kfr0*df

nfr=ceil((p.band.bf2-p.band.bf1)/p.fft.df);

A=zeros(nfr,nspect);
%tA=zeros(1,nspect);

for i = 1:nspect
   t=time+(i-1)*tspect*every/2; % interlaced
   tA(i)=t;
   fr1=doppler(t,fr0,alpha,delta,long,lat,coord);
   ind=ceil((fr1-frmin)/df);
   y=(randn(1,nfr).^2+randn(1,nfr).^2)/2;
   y(ind)=((randn(1,1)+sqrt(2*snr))^2+randn(1,1)^2)/2;
      a=y(ind);
   %   ind
   %   a
   A(:,i)=y.';
end

y=(0:nfr-1)*df+frmin;
%B=flipud(A);

figure;
%image(B,'XData',tA,'YData',y,'CDataMapping','scaled');
image(A,'XData',tA,'YData',y,'CDataMapping','scaled');
colorbar; zoom on;colormap hot

tfps=gd2(A');

dx=p.fft.tlen*p.fft.onev/(2*86400); % Interlaced !
dx2=p.fft.df;ini2=p.band.bf1;
capt='t-f power spectrum'; 
%p.tfmap.capt;
tfps=edit_gd2(tfps,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);

long=p.antenna.long;
lat=p.antenna.lat;
coord=p.hmap.type;

tfps=set_gd2_vdetect(tfps,long,lat,coord);



