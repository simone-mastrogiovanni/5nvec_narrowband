% freq_filtering
%
% to begin, create a sampled data gd named gdin
%
% example:  gdin=sds2gd('D:\Appo\dati\VIR_20041026_170000_xxxx_000.sds',1)

spin=gd_pows(gdin,'pieces',20,'window',2,'nobias');

% whitening filter
frfiltwh=1./sqrt(y_gd(spin));
frfiltwh1=create_frfilt(frfiltwh);

gdoutwhite=gd_frfilt(gdin,frfiltwh,1)
gdoutwhite1=gd_frfilt(gdin,frfiltwh1,1)

% wiener filter
sp=y_gd(spin);
sp1=mean_every(sp,1,20);
frfiltwi=min(sp1)./sp;
frfiltwi1=create_frfilt(frfiltwi);

gdoutwiener=gd_frfilt(gdin,frfiltwi,1)
gdoutwiener1=gd_frfilt(gdin,frfiltwi1,1)