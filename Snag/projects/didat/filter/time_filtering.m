% time_filtering
%
% to begin, create a sampled data gd named gdin
%
% example:  gdin=sds2gd('D:\Appo\dati\VIR_20041026_170000_xxxx_000.sds',1)

am1=crea_am('high',100/20000);
amf=am_multi(am1,am1);
amf.bilat=1;

x=y_gd(gdin);

y=am_filter(x,amf);

gdin1=gdin;
gdin1=edit_gd(gdin1,'y',y);