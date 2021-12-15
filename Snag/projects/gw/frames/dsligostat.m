%dsligostat  statistics for ligo antenna

l=10000;
[d,r]=inifr2ds(l,1,100000);

m=0;s=0;histout=zeros(1,200);histx=1:200;

for i =1:20
   [d,r]=fr2ds_fl(d,r,'ligo.dat','IFO_DMRO');
   [histout,histx,m,s]=stat_ds(d,histout,histx,m,s,'total','span',1.8);
   pause(2);
end
