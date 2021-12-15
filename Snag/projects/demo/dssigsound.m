l=8192;
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);

for i =1:20
   d=signal_ds(d,'whitenoise');
   y=y_ds(d);
   sound(y);
   pause(1);
end
