%dssigstat  ar running statistics for white noise
%     produces the mean, std vectors mm and ss

l=10000;
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);
m=0;s=0;histout=zeros(1,200);histx=1:200;

for i =1:20
   d=signal_ds(d,'whitenoise');
   [histout,histx,m,s]=stat_ds(d,histout,histx,m,s,'ar',4,'limit',-5,5);
   mm(i)=m;ss(i)=s;
   pause(2);
end
