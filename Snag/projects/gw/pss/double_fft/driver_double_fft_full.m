% driver_double_fft_full

pp=pulsar_3;
band=[108.85 108.95];
len=8000;
del=2500;
thr=0.001;
f_err=0.001;
d_err=-1e-12;

% pp=pulsar_5;
% band=[52.3 53.3];

[bsdin,~,~]=bsd_access('I:\','ligol','O2',1,band,2);% 
epoch_O1=57277;
pp=new_posfr(pp,epoch_O1)

bsdcor=bsd_dopp_sd(bsdin,pp);

out=double_fft(bsdcor,len,del,thr)

nf=round((pp.f0-band(1))/out.dfr1)+1

pp1=pp;
pp1.f0=pp.f0+f_err;
pp1.df0=pp.df0+d_err;

bsdcor1=bsd_dopp_sd(bsdin,pp1);

out1=double_fft(bsdcor1,len,del,thr)

out1.pp_corr=pp1;
out1.bsdin=bsdcor1;

outana1=ana_double_fft(out1,-20,2,80);