%dsrunning   use of running_ds

l=8192;
buff=zeros(1,3*(l/2));
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt);

sp=y_gd(gd_drawspect(dt,l*2,'virgo'));
ind=0;y=zeros(1,l);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   [y,ind]=running_ds(d,y,ind,'window',5,'lchunk',l/2,'delay',1);
end
