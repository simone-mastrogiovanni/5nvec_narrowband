%dsnoispows2   virgo noise continuous monitoring with comb no windowing

l=4096;
buff=zeros(1,3*(l/2));
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);
frcomb=(1:20)*100;
ampcomb=zeros(1,20);
combw=1;

gs=gd_drawspect(dt,l*2,'virgo','addcomb',combw,frcomb,ampcomb);
sp=y_gd(gs);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   powsout=pows_ds(d,powsout,'total','limit',0,5000,'loglog','sqrt');
   pause(2);
end
