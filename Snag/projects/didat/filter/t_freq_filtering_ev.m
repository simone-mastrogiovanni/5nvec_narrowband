% t_freq_filtering_ev
%
% to begin, create a sampled data gd named gdin
%
% example:  gdin=sds2gd('D:\Appo\dati\VIR_20041026_170000_xxxx_000.sds',1)
% and event gd as with 
%   gdev=sds2gd('D:\Appo\datiev\VIR_20041026_170000_xxxx_000.sds',1)

am1=crea_am('high',100/20000);
amf=am_multi(am1,am1);
amf.bilat=1;

x=y_gd(gdin);
xev=y_gd(gdev);

x=am_filter(x,amf);
gdin1=gdin;
gdin1=edit_gd(gdin1,'y',x);

xev=am_filter(xev,amf);
gdev1=gdev;
gdiev=edit_gd(gdev1,'y',xev);

spin=gd_pows(gdin1,'pieces',20,'window',2,'nobias');

% whitening filter
frfiltwh=1./sqrt(y_gd(spin));
frfiltwh=create_frfilt(frfiltwh);

gdoutwhite=gd_frfilt(gdin1,frfiltwh,1)
gdoutwhitev=gd_frfilt(gdev1,frfiltwh,1)

% wiener filter
sp=y_gd(spin);
sp1=mean_every(sp,1,20);
frfiltwi=min(sp1)./sp;
frfiltwi=create_frfilt(frfiltwi);

gdoutwiener=gd_frfilt(gdin1,frfiltwi,1)
gdoutwienerev=gd_frfilt(gdev1,frfiltwi,1)


% filter again for wiener

x=y_gd(gdoutwiener);
xev=y_gd(gdoutwienerev)*10/8.07e-2;

x=am_filter(x,amf);
gdoutwiener=edit_gd(gdoutwiener,'y',x);

xev=am_filter(xev,amf);
gdoutwienerev=edit_gd(gdoutwienerev,'y',xev);

gdtot=gdoutwiener+gdoutwienerev