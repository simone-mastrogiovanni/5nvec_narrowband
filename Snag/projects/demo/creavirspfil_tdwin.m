% creavirspfil_tdwin
snag_local_symbols
fr=50*(1:20);
am=zeros(1,20);
vsp=gd_drawspect(0.00025,16384,'virgo','slope',3.5,'lowfr',6,'addcomb',1,fr,am)

vsp1=tdwin(y_gd(vsp),'sqrt','hhole','real');
virsptdw=edit_gd(vsp,'y',vsp1);

specname='virsptdw';
save([specdir 'virsptdw'],'virsptdw','specname')
