l=20000;

[d,r]=inifr2ds(l,1,100000);

for i =1:20
   [d,r]=fr2ds_fl(d,r,'ligo.dat','IFO_DMRO');
   y=y_ds(d);
   sound(y);
   pause(1);
end
