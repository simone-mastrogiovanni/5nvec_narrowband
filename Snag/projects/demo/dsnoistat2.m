%dsnoistat2  statistics for virgo antenna with comb

l=4096;
buff=zeros(1,3*(l/2));
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt);
frcomb=(1:20)*100;
ampcomb=zeros(1,20);
combw=1;

sp=y_gd(gd_drawspect(dt,l*2,'virgo','addcomb',combw,frcomb,ampcomb));

m=0;s=0;histout=zeros(1,200);histx=1:200;

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   [histout,histx,m,s]=stat_ds(d,histout,histx,m,s,'total','span',1.8);
   pause(2);
end
