%dsnoisound1  "sound" of the virgo antenna with comb

l=81920;
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);
buff=zeros(1,3*(l/2));
frcomb=(1:20)*100;
ampcomb=zeros(1,20);
combw=1;

sp=y_gd(gd_drawspect(dt,l*2,'virgo','addcomb',combw,frcomb,ampcomb));

[d,buff]=noise_ds(d,buff,'spect',sp);
y=y_ds(d);
amp=std(y)

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   y=y_ds(d)./(amp*0.001);
   sound(y);
   pause(10);
end
