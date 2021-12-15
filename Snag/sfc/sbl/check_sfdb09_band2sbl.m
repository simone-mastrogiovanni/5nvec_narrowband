function sim=check_sfdb09_band2sbl(sour,ant,dt,N)

source1=sour;
source1.eps=1;
source1.psi=0;
source2=sour;
source2.eps=1;
source2.psi=45;

f0=sour.f0;
df0=sour.df0;
ddf0=sour.ddf0;
fr0=f0

nsid=1000;
dsid=24/nsid;
sid1=zeros(1,nsid);
sid2=sid1;
for i = 1:nsid
    tsid=i*dsid;
    sid1(i)=lin_radpat_interf(source1,ant,tsid);
    sid2(i)=lin_radpat_interf(source2,ant,tsid);
end

eps=sour.eps;
psi=sour.psi*pi/180;
fi=2*psi;

tt=dt*(0:N-1);
ph=f0*tt*2*pi;
st=gmst(tt/86400);
i1=mod(round(st*(nsid-1)/24),nsid-1)+1;eps,fi

xc=cos(ph+fi)*sqrt(1-eps)/sqrt(2); % !!!  CORREGGERE
yc=sin(ph+fi)*sqrt(1-eps)/sqrt(2); % !!!  CORREGGERE
xl=cos(ph)*sqrt(eps)*sin(2*psi);
yl=cos(ph)*sqrt(eps)*cos(2*psi); % size(i1),size(xc),size(xl),size(yc),size(yl),size(sid1)
sim=(sid1(i1).*(xc+xl)+sid2(i1).*(yc+yl));

figure,plot(tt,sim)