function [tfmap,p]=pss_peakmaptest(p)
%PSS_PEAKMAP   creates a power spectrum test peak map 
%
%     [tfmap,p]=pss_peakmaptest(p)
%
%   psspar  pss_par structure
%
%   tfmap   gd2 of the time-frequency map

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

rad2deg=180/pi;

%tA=zeros(1,nspect);

df=p.fft.df;

nfr=ceil((p.band.bf2-p.band.bf1)/p.fft.df);

npeaktot=nfr;

for i = 1:nfr
   i2(i)=i;
   j2(i)=1;
   s2(i)=1;
end

A=sparse(i2,j2,s2,nfr,nspect);
if p.source.snr == -2
    A=A*0;
    i=ceil(2*nfr/3);
    j=ceil(nspect/2);
    npeaktot=1;
    stri=sprintf('  i   (max %d)',nfr);
    strj=sprintf('  j   (max %d)',nspect);
    stri0=sprintf('%d',i);
    strj0=sprintf('%d',j);
    answ=inputdlg({stri,strj},'Non-zero element',1,{stri0,strj0});
    i=eval(answ{1});
    j=eval(answ{2});

    A(i,j)=1;
end

p.tfmap.npeaktot=npeaktot;

figure;
spy(A);

tfmap=gd2(A');
dx=p.fft.tlen*p.fft.onev/(2*86400); % Interlaced !
dx2=p.fft.df;ini2=p.band.bf1;
capt=p.tfmap.capt;
tfmap=edit_gd2(tfmap,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);

long=p.antenna.long;
lat=p.antenna.lat;
coord=p.hmap.type;

%tfmap=set_gd2_vdetect(tfmap,long,lat,coord);
t=time+(0:nspect-1)*tspect*every/2; % interlaced
[fr1,a,d,v]=vdoppler(t,fr0,alpha,delta,long,lat,coord,0);size(a)

tfmap=set_gd2_v(tfmap,a*rad2deg,d*rad2deg,v);
