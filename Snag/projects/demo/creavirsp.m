fr=50*(1:20);
am=zeros(1,20);
virrough=gd_drawspect(0.00025,16384,'virgo','slope',3.5,'lowfr',6,'addcomb',1,fr,am)

vsp1=tdwin(y_gd(virrough),'real','hhole');
virtd1=edit_gd(virrough,'y',vsp1);

vsp1=tdwin(y_gd(virrough),'real','hhole','amplitude',0.01);
virtd2=edit_gd(virrough,'y',vsp1);

vsp1=tdwin(y_gd(virrough),'real','hhole','amplitude',0.02);
virtd3=edit_gd(virrough,'y',vsp1);

vsp1=tdwin(y_gd(virrough),'real','hhole','cosine','amplitude',0.05);
virtd4=edit_gd(virrough,'y',vsp1);

vsp1=tdwin(y_gd(virrough),'real','hhole','gauss','amplitude',0.1);
virtd5=edit_gd(virrough,'y',vsp1);
