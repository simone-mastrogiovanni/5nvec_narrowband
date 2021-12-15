function g=gd_drawspect(varargin)
%GD_DRAWSPECT  puts a spectrum in a gd
%
%  arg1 = dt
%  arg2 = len (for many purposes, should be a power of 2)
%
%  keys :
%     'lorentz'
%     'gauss'
%     'clorentz'   complex lorentzian
%     'virgo'
%
%     'frequency'  followed by the fr
%     'bandwidth'  followed by the bw
%     'amplitude'  followed by the amp
%     'hflat'           "     "    hflat - for Virgo
%     'hlow'            "     "    hlow  - for Virgo
%     'hhigh            "     "    hhigh - for Virgo
%     'slope'           "     "    slope - for Virgo
%     'lowfr'           "     "    lowfr - for Virgo
%     'addcomb'         "   by a double "combw" with the width (in samples)
%                            and two arrays frcomb and ampcomb
%                            (ampcomb(i)=0 -> ampcomb= 20*hlow)
%                             ATTENTION ! put it at the end
%
%     'singlesided'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=varargin{1};
len=varargin{2};
len1=len;

fr=0;
bw=1;
amp=1;
hflat=10^-23;
icsp=1;
icss=0;
addcomb=0;
a=zeros(1,len1);

for i = 3:length(varargin)
   str=varargin{i};
   switch str
   case 'lorentz'
      icsp=1;
      capt='lorentzian spectrum';
   case 'gauss'
      icsp=2;
      capt='gaussian spectrum';
   case 'clorentz'
      icsp=3;
      capt='complex lorentzian spectrum';
   case 'virgo'
      icsp=4;
      hflat=10^(-23);
      slope=3;
      hlow=hflat*100^slope;
      hhigh=hflat/500;
      lowfr=10;
      capt='simulated virgo spectrum';
   case 'frequency'
      fr=varargin{i+1};
   case 'bandwidth'
      bw=varargin{i+1};
   case 'amplitude'
      amp=varargin{i+1};
   case 'singlesided'
      icss=1
   case 'addcomb'
      break;
   end
end

for i = 3:length(varargin)
   str=varargin{i};
   switch str
   case 'hflat'
      hflat=varargin{i+1};
   case 'hlow'
      hlow=varargin{i+1};
   case 'hhigh'
      hhigh=varargin{i+1};
   case 'slope'
      slope=varargin{i+1};
   case 'lowfr'
      lowfr=varargin{i+1};
   case 'addcomb'
      combw=varargin{i+1};
      frcomb=varargin{i+2};
      ampcomb=varargin{i+3};
      addcomb=1;
      break;
   end
end

if icss == 1
   len=len*2;
end

len2=len/2;
df=1/(dt*len);

if addcomb == 1
   kcomb=frcomb;
   for i = 1:length(frcomb)
      if ampcomb(i) <= 0
         ampcomb(i)=20*hflat*len/16364;
      end
      kcomb(i)=ceil(frcomb(i)/df);
   end
end

switch icsp
case 1
   bw2=bw^2;
   a(1)=bw2/(fr^2+bw2);
   for i = 2:len2
      f=(i-1)*df;
      a(i)=bw2/((f-fr)^2+bw2);
      if icss == 0
         a(len+2-i)=a(i);
      end
   end
   if icss == 0
      a(len2+1)=a(len2);
   end
case 2
   bw2=bw^2;
   a(1)=exp(-fr^2/bw2);
   for i = 2:len2
      f=(i-1)*df;
      a(i)=exp(-(f-fr)^2/bw2);
      if icss == 0
         a(len+2-i)=a(i);
      end
   end
   if icss == 0
      a(len2+1)=a(len2);
   end
case 3
   bw2=bw^2;
   for i = 1:len2
      f=(i-1)*df;
      a(i)=bw2/((f-fr)^2+bw2);
      if icss == 0
         ii=i+len2;
         ff=(ii-1)*df;
         a(ii)=bw2/((ff-fr)^2+bw2);
      end
   end
case 4
   for i = 2:len2
      f=(i-1)*df;
      if f < lowfr
         f=lowfr;
      end
      a(i)=hflat+hlow/f^slope+hhigh*f;
      if icss == 0
         a(len+2-i)=a(i);
      end
   end
   a(1)=a(2);
   if icss == 0
      a(len2+1)=a(len2);
   end
   a=a.*a;
end

if addcomb == 1
   for i = 1:length(frcomb)
      a(kcomb(i))=(sqrt(a(kcomb(i)))+ampcomb(i)).^2;
      a(len+2-kcomb(i))=a(kcomb(i));
      for ii = 1:combw
         aa=ampcomb(i)*(1/(1+(ii/combw)^2));
         a(kcomb(i)+ii)=(sqrt(a(kcomb(i)+ii))+aa).^2;
         a(kcomb(i)-ii)=(sqrt(a(kcomb(i)-ii))+aa).^2;
         a(len+2-kcomb(i)-ii)=a(kcomb(i)+ii);
         a(len+2-kcomb(i)+ii)=a(kcomb(i)-ii);
      end
   end
end

g=gd(a(1:len1));
a=amp.*a;
g=edit_gd(g,'n',len1,'dx',df,'capt',capt);

   