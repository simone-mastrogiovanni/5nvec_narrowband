function [g,tafd]=gd_chirp_2(varargin)
%GD_CHIRP  chirp (second version)
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
% 'plot'    plot

% Version 2 - October 2018 (from 1.0 - July 1998)
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2018  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=0.0001;
fmin=100;
fmax=1000;
ct=2.5;
len=32768;
amp=1;
icpl=0;
icmplx=0;

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
      case 'plot'
         icpl=1;
      case 'cmplx'
         icmplx=1;
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

tafd=zeros(nmax,5);
tafd(:,1)=(0:nmax-1)*dt-ct;
tafd(:,2)=a(1:nmax);
tafd(:,3)=f(1:nmax);
tafd(:,4)=1./a(1:nmax);

pi2=2*pi;
do=pi2*dt;
ph=cumsum(f)*do;
ph=mod(ph,pi2);
tafd(:,5)=ph(1:nmax);

if icmplx
    a=(amp.*a).*exp(1j*ph);
else
    a=(amp.*a).*cos(ph);
end

g=gd(a);

g=edit_gd(g,'dx',dt,'capt','chirp');

if icpl
    figure,plot(g),title('chirp'),xlabel('s')
    figure,loglog(-tafd(:,1),tafd(:,3)),grid on,title('frequency')
        xlabel('time before coalescence (s)'),ylabel('Hz')
        hold on,loglog(-tafd(:,1),tafd(:,3),'r.')
    figure,loglog(-tafd(:,1),tafd(:,2)),grid on,title('amplitude')
        xlabel('time before coalescence (s)')
        hold on,loglog(-tafd(:,1),tafd(:,2),'r.')
end