fr=50*(1:20);
am=zeros(1,20);
vsp=gd_drawspect(0.00025,8192,'virgo','slope',3.5,'lowfr',6,'addcomb',1,fr,am)

vsp1=spec_2l(y_gd(vsp));
vsp1=edit_gd(vsp,'y',vsp1,'n',16384);