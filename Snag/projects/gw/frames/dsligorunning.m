%dsligorunning   use of running_ds

l=10000;
[d,r]=inifr2ds(l,1,100000);

ind=0;y=zeros(1,l);

for i =1:20
   [d,r]=fr2ds_fl(d,r,'ligo.dat','IFO_DMRO');
   [y,ind]=running_ds(d,y,ind,'window',5,'lchunk',l/2,'delay',1);
end
