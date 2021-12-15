%dsnoisound  "sound" of the virgo antenna

l=81920;
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);
buff=zeros(1,3*(l/2));

s=y_gd(gd_drawspect(dt,l*2,'virgo'));

[d,buff]=noise_ds(d,buff,'spect',s);
y=y_ds(d);
amp=max(abs(y))

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',s);
   y=y_ds(d)./amp;
   sound(y);
   pause(10);
end
