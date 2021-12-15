snag_local_symbols
fr=50*(1:20);
am=zeros(1,20);
vsp=gd_drawspect(0.00025,8192,'virgo','slope',3.5,'lowfr',6,'addcomb',1,fr,am)

vsp1=spec_2l(y_gd(vsp));
virs2l=edit_gd(vsp,'y',vsp1,'n',16384,'dx',dx_gd(vsp)/2);

specname='virs2l';
save([specdir 'virs2l'],'virs2l','specname')
