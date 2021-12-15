%dssigpows1   white noise continuous monitoring

l=4096;
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);

for i =1:20
   d=signal_ds(d,'whitenoise');
   powsout=pows_ds(d,powsout,'total','limit',1000,2000);
   pause(2);
end
