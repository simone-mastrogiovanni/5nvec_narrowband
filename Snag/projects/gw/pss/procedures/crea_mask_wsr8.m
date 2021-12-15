% crea_mask_wsr8

% [spfr,sptim,peakfr8,peaktim,npeak,splr,peaklr,mub,sigb]=ana_peakmap(0,0,0,0);

nofr=read_virgolines(10,2000);

[nl,i2]=size(nofr)

% nofr(nl+1,1)=250;
% nofr(nl+1,2)=-1;
% nofr(nl+1,3)=20;
% nofr(nl+2,1)=444;
% nofr(nl+2,2)=-1;
% nofr(nl+2,3)=2;
% nofr(nl+3,1)=609;
% nofr(nl+3,2)=-1;
% nofr(nl+3,3)=2;
% nofr(nl+4,1)=810;
% nofr(nl+4,2)=-1;
% nofr(nl+4,3)=6;
% nofr(nl+5,1)=810;
% nofr(nl+5,2)=-1;
% nofr(nl+5,3)=6;

% mask=crea_cleaningmask(peakfr8,nofr,[[10 0 0.1 0];[2.705165 -1 0.1 2]],0);
mask=crea_cleaningmask(peakfr8,nofr,[[10 0 0.1 0];[2.7105 -1 0.1 2]],0);