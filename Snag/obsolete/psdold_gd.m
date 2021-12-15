function a=psd_gd(b,param)
%GD/PSD_GD   phase sensitive detector (lock-in)
%
%      a=psd_gd(b,param)
%       or
%      a=psd_gd(b)
%
%    param(1)   frequency
%    param(2)   tau (0 -> no)
%    param(3)   number of poles
%    param(4)   cut frequency (0 -> no)

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;

if ~exist('param')
   answ1=inputdlg({'Frequency' 'Tau' 'Number of poles' 'HF cut frequency'},...
      'Parameters of the lock-in',1,{'1' '1' '1' '0'});
   
   param(1)=eval(answ1{1});
   param(2)=eval(answ1{2});
   param(3)=eval(answ1{3});
   param(4)=eval(answ1{3});
end

fr=param(1);
tau=param(2);
npol=param(3);
cutfr=param(4);

s=mod((0:a.n-1).*(a.dx*fr),1).*(2*pi*j);
s=exp(s);

a.y=a.y.*s';

if tau ~= 0
   f0=1/(2*pi*tau);
   nn=2^floor(log(a.n)/log(2));
   if nn < a.n
      nn=nn*2;
   end
   s=a.y;nn
   if nn > a.n
      s(a.n+1:nn)=0;
   end
   n=length(s)
   s=fft(s);
   f=(0:(nn/2-1))./(nn*a.dx);
   f(1:nn/2)=f0^npol./(f0+f).^npol;
   f(nn/2+2:nn)=f(nn/2:-1:2);
   f(nn/2+1)=f(nn/2);
   %f=ones(1,n);
   size(s),size(f)
   s=s.*f';
   a.y=ifft(s);
end

if cutfr ~= 0
   s=fft(a.y);
   
   nc=1/(cutfr*a.dx);
   nc1=floor(nc+(n-nc)*0.05+1);
   
   for i = nc:nc1
      s(i)=s(i)*(nc1-i)/(nc1-nc);
   end
   
   s(nc1+1:n)=0;
   
   a.y=ifft(s);
end

a.y=a.y(1:a.n);
a.y=a.y(:);
a.capt=['lock-in on ' a.capt];
