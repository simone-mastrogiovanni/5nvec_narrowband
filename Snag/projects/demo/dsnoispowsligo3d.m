%dsnoispows3dligo   ligo 40m noise continuous monitoring 

l=16384;
buff=zeros(1,3*(l/2));
powsout=zeros(1,l);
d=ds(l);
dt=0.0001;
typ=2;
d=edit_ds(d,'dt',dt,'type',typ);

setsnag
load data\ligospec.mat;
sp=y_gd(gdspligo);

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);

answ=inputdlg({'Number of spectra ?' 'Average on how many ?'...
   'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {'100' '10' '0' sfr});
dslen=l;
nspec=eval(answ{1});
aver=eval(answ{2});
frmin=eval(answ{3});
frmax=eval(answ{4});

n1=floor(frmin*dslen/(2*frmax0)+1);
n2=floor(frmax*dslen/(2*frmax0));
dn=n2-n1+1;
frmin1=(n1-1)*2*frmax0/dslen;
frmax1=n2*2*frmax0/dslen;

amap=zeros(dn,nspec);

frmax=1/(2*dt);

for i =1:nspec
   amap(:,i)=zeros(dn,1);
   for j=1:aver
      [d,buff]=noise_ds(d,buff,'spect',sp);
      powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
      amap(:,i)=amap(:,i)+powsout';
   end
end

dx=dt*dslen*aver/typ;
dx2=1/(dt*dslen);

amap=amap.';
map=gd2(amap);
map=edit_gd2(map,'dx',dx,'dx2',dx2,'ini2',frmin1);
