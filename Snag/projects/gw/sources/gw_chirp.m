function out=gw_chirp(varargin)
%GW_CHIRP  chirp
%
% keys :
%
% 'dt'      sampling time (in s)
% 'masc'    chirp mass (in solar masses)
% 'fmin'    fmin
% 'fmax'    fmax
% 'ct'      coalescence time
% 'len'     length (0 -> computes default)
% 'amp'     amplitude; if amp=0 -> computes the amplitude at 100 Mpc
% 'ringf'   ring-down frequency
% 'ringa'   ring-down amplitude (respect to merge maximum)
% 'ringt'   ring-down tau
% 'gd'      use gd (icgd = 1) (def icgd=0)

% Version 2.0 - April 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=0.0001;
fmin=30;
fmax=400;
ct=2.5;
len=32768;
amp=1;
ringf=300;
ringa=0.2;
ringt=0.02;
icgd=0;

for i = 1:length(varargin)
   strin=varargin{i};
   switch strin
      case 'dt'
         dt=varargin{i+1};
      case 'masc'
         mc=varargin{i+1};
      case 'fmin'
         fmin=varargin{i+1};
      case 'fmax'
         fmax=varargin{i+1};
      case 'ct'
         ct=varargin{i+1};
      case 'len'
         len=varargin{i+1};
      case 'amp'
         amp=varargin{i+1};
      case 'ringf'
         ringf=varargin{i+1};
      case 'ringa'
         ringa=varargin{i+1};
      case 'ringt'
         ringt=varargin{i+1};
       case 'gd'
           icgd=1;
   end
end

if amp == 0
   amp=2.56*10^23*(ct/3)^(-1)*(fmin/100)^(-2);
end
out.amp=amp;

nmax=ct/dt;
if len > 0
    if nmax > len
       nmax=len;
    end
else
    len=round(nmax*1.1);
end

f=zeros(1,len);
a=f;
d=f;
a(1:nmax)=((1:nmax)-.5)*dt;
a(1:nmax)=(1-a(1:nmax)/ct).^-0.25;
f(1:nmax)=fmin*a(1:nmax).^1.5;%figure,plot(f)
d(1:nmax)=1./a(1:nmax);

pi2=2*pi;
do=pi2*dt;
ph=cumsum(f)*do;
ph=mod(ph,pi2);
h=(amp.*a).*cos(ph);

ii=find(f > fmax);
if ~isempty(ii)
    nmax1=ii(1);
else
    nmax1=nmax;
end
nmax2=nmax*2-nmax1;
amax1=a(nmax1);
% a(nmax1:nmax)=amax1+(a(nmax1:nmax)-amax1)/2; % MERGE: to work on
if ringa > 0
    amax2=max(a)*ringa;
    nring=round(ringt*4/dt); %nmax,nmax1,nring,amax2,dt,ringt
    f(nmax+1:nmax+nring)=ringf; 
    a(nmax+1:nmax+nring)=amax2*exp(-(1:nring)*dt/ringt);
    h(nmax+1:nmax+nring)=sign(h(nmax))*amax2*cos(2*pi*(1:nring)*dt*ringf).*exp(-(1:nring)*dt/ringt);
end

if nmax2 > nmax1+4
    nmerge=nmax2-nmax1+1;
    ii=[1 2 3 4 nmerge-1 nmerge];
    hh=[h(nmax1+1) h(nmax1+2) h(nmax1+3) h(nmax1+4) h(nmax2-1) h(nmax2)];
    hmerge=spline(ii,hh,1:nmerge);
    h(nmax1:nmax2)=hmerge;
    out.hmerge=hmerge;
end
   
if icgd == 0
    out.dt=dt;
    out.f=f;
    out.a=a;
    out.d=d;
    out.t=(0:len-1)*dt;
    out.h=h;
else
    f=gd(f);
    f=edit_gd(f,'dx',dt,'capt','chirp frequency');
    out.f=f;
    a=gd(a);
    a=edit_gd(a,'dx',dt,'capt','chirp amplitude');
    out.a=a;
    d=gd(d);
    d=edit_gd(d,'dx',dt,'capt','chirp distance');
    out.d=d;
    h=gd(h);
    h=edit_gd(h,'dx',dt,'capt','chirp h');
    out.h=h;
end
