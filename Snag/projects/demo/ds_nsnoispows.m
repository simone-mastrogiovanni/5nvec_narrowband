%dsnoispows   virgo noise continuous monitoring

l=4096;
buff=zeros(1,3*(l/2));
d=ds(l);
dt=0.0001;
powsout=0;
d=edit_ds(d,'dt',dt,'type',1);
gs=gd_drawspect(dt,l,'virgo');

sp=y_gd(gs);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   powsout=pows_ds(d,powsout,'total','limit',0,5000,'loglog','sqrt','hwindow');
   pause(2);
end
