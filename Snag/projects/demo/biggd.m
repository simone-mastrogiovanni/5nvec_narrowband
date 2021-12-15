%biggd  from a ds

y=zeros(1,10000);
bg=gd(y);
d=ds(1024);
d=edit_ds(d,'type',1);
cont=0;
d=reset_ds(d);
while cont < 10000
   d=signal_ds(d,'ramp');
   y1=y_ds(d);
   bg=multy2gd_gd(bg,y1);
   cont=cont_gd(bg);
end