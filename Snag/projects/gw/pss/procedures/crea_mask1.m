% crea_mask1

% [spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,'peakmap-C7.vbl');

nofr=read_virgolines(10,2000);

[nl,i2]=size(nofr)

nofr(nl+5,1)=250;
nofr(nl+5,2)=-1;
nofr(nl+5,3)=20;
nofr(nl+5,4)=2;
nofr(nl+4,1)=444;
nofr(nl+4,2)=-1;
nofr(nl+4,3)=2;
nofr(nl+4,4)=2;
nofr(nl+1,1)=609;
nofr(nl+1,2)=-1;
nofr(nl+1,3)=2;
nofr(nl+1,4)=2;
nofr(nl+2,1)=810;
nofr(nl+2,2)=-1;
nofr(nl+2,3)=6;
nofr(nl+2,4)=2;
nofr(nl+3,1)=810;
nofr(nl+3,2)=-1;
nofr(nl+3,3)=6;
nofr(nl+3,4)=2;

mask=crea_cleaningmask(peakfr,nofr,[50 0 0.1 0.001],0);