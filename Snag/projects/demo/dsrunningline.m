%dsrunningline   use of running_ds

l=8192;
buff=zeros(1,3*(l/2));
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt);

sp=zeros(1,8192);sp(1)=1;%sp(8191)=1;
sp=fft(sp);

%sp=spvignette(sp,0.5,'cosi');
for i = 2:2048
   sp(i)=sp(i)*(2048-i+1)/2048;
   sp(8194-i)=sp(i);
end
sp(2049:2048+4096)=0;

sp=ifft(sp);sp=real(sp);sp(5:8188)=0;

ind=0;y=zeros(1,l);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   [y,ind]=running_ds(d,y,ind,'window',3,'lchunk',l/2,'delay',1);
end
