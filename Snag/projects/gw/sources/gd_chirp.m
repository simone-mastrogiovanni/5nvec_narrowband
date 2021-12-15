function g=gd_chirp(varargin)
%GD_CHIRP  chirp
%
% keys :
%
% 'dt'      sampling time (in s)
% 'masc'    chirp mass (in solar masses)
% 'fmin'    fmin
% 'fmax'    fmax
% 'ct'      coalescence time
% 'len'     length
% 'amp'     amplitude; if amp=0 -> computes the amplitude at 100 Mpc
%
% 'outf'    outputs the frequency
% 'outd'    outputs the distance
% 'outa'    outputs the amplitude

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=0.0001;
fmin=100;
fmax=1000;
ct=2.5;
len=32768;
amp=1;
ic=0;

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
      case 'outf'
         ic=1;
      case 'outa'
         ic=2;
      case 'outd'
         ic=3;
   end
end

if amp == 0
   amp=2.56*10^23*(ct/3)^(-1)*(fmin/100)^(-2);
end

nmax=round(ct/dt);
if nmax > len
   nmax=len;
end

f=zeros(1,len);
a=f;
a(1:nmax)=((1:nmax)-.5)*dt;
a(1:nmax)=(1-a(1:nmax)/ct).^-0.25;
f(1:nmax)=fmin*a(1:nmax).^1.5;

if ic == 1
   g=gd(f);
   g=edit_gd(g,'dx',dt,'capt','chirp frequency');
elseif ic == 2
   g=gd(a);
   g=edit_gd(g,'dx',dt,'capt','chirp amplitude');
elseif ic == 3
   a(1:nmax)=1./a(1:nmax);
   g=gd(a);
   g=edit_gd(g,'dx',dt,'capt','stars distance');
else
   pi2=2*pi;
   do=pi2*dt;
   f=cumsum(f)*do;
   f=mod(f,pi2);
   a=(amp.*a).*cos(f);	

   g=gd(a);

   g=edit_gd(g,'dx',dt,'capt','chirp');
end
