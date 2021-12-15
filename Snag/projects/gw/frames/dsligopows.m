%dsligopows   ligo data continuous monitoring

l=4096;
[d,r]=inifr2ds(l,1,100000);

for i =1:20
   [d,r]=fr2ds_fl(d,r,'ligo.dat','IFO_DMRO');
   powsout=pows_ds(d,powsout,'total','limit',11,5000,'loglog','sqrt','hwindow');
   pause(2);
end
