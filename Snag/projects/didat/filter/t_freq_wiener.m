% t_freq_wiener
%
% to begin, create a sampled data gd named gdin
%
% example:  gdin=sds2gd('D:\Appo\dati\VIR_20041026_170000_xxxx_000.sds',1)

am1=crea_am('high',100/20000);
amf=am_multi(am1,am1);
amf.bilat=1;

x=y_gd(gdin);

x=am_filter(x,amf);
gdin1=gdin;
gdin1=edit_gd(gdin1,'y',x);

spin=gd_pows(gdin1,'pieces',20,'window',2,'nobias');

% wiener filter
sp=y_gd(spin);
sp1=mean_every(sp,1,20);
frfiltwi=min(sp1)./sp;
frfiltwi=create_frfilt(frfiltwi);

gdoutwiener=gd_frfilt(gdin1,frfiltwi,1)

% filter again for wiener

x=y_gd(gdoutwiener);

x=am_filter(x,amf);
gdoutwiener=edit_gd(gdoutwiener,'y',x);

