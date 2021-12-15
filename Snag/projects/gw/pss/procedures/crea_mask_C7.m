% crea_mask

% [spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0,'peakmap-C7.vbl');

nofr=read_virgolines(10,2000);

[nl,i2]=size(nofr)

nofr(nl+5,1)=167.5;
nofr(nl+5,2)=-1;
nofr(nl+5,3)=2;
nofr(nl+4,1)=353.5;
nofr(nl+4,2)=-1;
nofr(nl+4,3)=5.5;
nofr(nl+1,1)=950;
nofr(nl+1,2)=-1;
nofr(nl+1,3)=6;
nofr(nl+2,1)=1002;
nofr(nl+2,2)=-1;
nofr(nl+2,3)=4;
nofr(nl+3,1)=1340;
nofr(nl+3,2)=-1;
nofr(nl+3,3)=10;

mask=crea_cleaningmask(peakfr,nofr,[[10 0 1 0];[99.1886 0 0.01 0.001]],0);