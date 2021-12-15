function HM=pss_hough(p,pm)
%PSS_HOUGH  computes a Hough map from a tfmap (in a gd2)
%
%      HM=pss_hough(psspar,tfmap)
%
%   psspar  pss_par structure
%   pm      peak map structure
%   
%   HM      a gd2 containing the Hough transform map

% Version 2.0 - August 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


rad2deg=180/pi;
deg2rad=pi/180;

frmin=pm.frin;
df=pm.dfr;
% tmin=ini_gd2(tfmap);
% dt=dx_gd2(tfmap);

[i1,j1]=find(pm.PM); % i1 -> frequency, j1 -> time 
npeak=length(i1);

vx=pm.v(j1,1)';
vy=pm.v(j1,2)';
vz=pm.v(j1,3)'; size(vz)

if p.hmap.type == 1
    for j = 1:length(vx)
        v=rect_eq2ecl([vx(j),vy(j),vz(j)]);
        vx(j)=v(1);
        vy(j)=v(2);
        vz(j)=v(3);
    end
    disp('ecliptical coordidates')
else
    disp('equatorial coordidates')
end

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

fr1=frmin+(i1-1).*df;

cosfi1=(fr1-fr01)'./fr0;
cosfi2=(fr1-fr02)'./fr0;

d=d1+(0:nd-1).*dd;
a=a1+(0:na-1).*da;
cz=cos(d);
ca=cos(a);
sa=sin(a);
z=sin(d);

disp('start')

HM=zeros(na,nd);

for j = 1:nd
   if j/30 == floor(j/30)
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

[mapmax,i,j]=find_max(HM);
a=(a1+(i-1)*da)/deg2rad;
d=(d1+(j-1)*dd)/deg2rad;
str=sprintf(' ---> max = %d  at a,d = %f, %f \n',mapmax,a(1),d(1));
disp(str)

if p.hmap.type == 1
    [a,d]=astro_coord('ecl','equ',a(1),d(1));
    str=sprintf(' Eq.Coord. ---> a,d = %f, %f \n',a,d);
    disp(str)
end

snr=mapmax/sqrt(weight)

HM=gd2(HM);
HM=edit_gd2(HM,'dx',p.hmap.da,'dx2',p.hmap.dd,'ini',0,'ini2',-90,...
   'capt','Hough Transform Map');