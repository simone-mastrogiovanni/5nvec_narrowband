function HM=pss_hough(p,tfmap)
%PSS_HOUGH  computes a Hough map from a tfmap (in a gd2)
%
%      HM=pss_hough(psspar,tfmap)
%
%   psspar  pss_par structure
%   tfmap   gd2 of the time-frequency map
%   
%   HM      a gd2 containing the Hough transform map

rad2deg=180/pi;
deg2rad=pi/180;

frmin=ini2_gd2(tfmap);
df=dx2_gd2(tfmap);
tmin=ini_gd2(tfmap);
dt=dx_gd2(tfmap);

[i1,j1]=findtr_gd2(tfmap); % i1 -> frequency, j1 -> time (ordered)
npeak=length(i1);

[va1,vd1,ve1]=get_gd2_vdetect(tfmap);size_va1=size(va1)
va1=va1*deg2rad;
vd1=vd1*deg2rad;
vvx=cos(va1).*cos(vd1).*ve1;
vvy=sin(va1).*cos(vd1).*ve1;
vvz=sin(vd1).*ve1;

vx=vvx(j1)';
vy=vvy(j1)';
vz=vvz(j1)';

long=p.antenna.long;
lat=p.antenna.lat;
coord=p.hmap.type;
fr0=p.band.f0;
hdf=df*p.mapping.kdf;
fr01=fr0-hdf;
fr02=fr0+hdf;
if length(fr01) > 1
   disp('This is a mystery error')
   hdf,fr0,df,fr01,fr02
end

na=p.hmap.na;
nd=p.hmap.nd;
a1=p.hmap.a1*deg2rad;
d1=p.hmap.d1*deg2rad;
da=p.hmap.da*deg2rad;
dd=p.hmap.dd*deg2rad;

fr1=zeros(1,npeak);

%fr1=frmin+(i1-1).*df; fr01
fr1=frmin+(i1-1).*df;

cosfi1=(fr1-fr01)./fr0;
cosfi2=(fr1-fr02)./fr0;
%% size(cosfi),size(cosfi1)

d=d1+(0:nd-1).*dd;
a=a1+(0:na-1).*da;
cz=cos(d);
ca=cos(a);
sa=sin(a);
z=sin(d);

HM=zeros(na,nd);

for j = 1:nd
   if j/10 == floor(j/10)
      d(j)*rad2deg
   end
   x=ca.*cz(j);
   y=sa.*cz(j);
   for i = 1:na
      cosfi=x(i).*vx+y(i).*vy+z(j).*vz;
      wpix=find(cosfi<cosfi1&cosfi>cosfi2);
      HM(i,j)=length(wpix);
   end
end

weight=sum(HM(:))/(na*nd)
mapmax=max(HM(:))
snr=mapmax/sqrt(weight)

HM=gd2(HM);
HM=edit_gd2(HM,'dx',p.hmap.da,'dx2',p.hmap.dd,'ini',0,'ini2',-90,...
   'capt','Hough Transform Map');