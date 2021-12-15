function a=psd1_gd(b,param)
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
   w=exp(-a.dx/tau);
   ww=0;
   yy=0;
   
   for i = 1:a.n
      yy=a.y(i)+w*yy;
      ww=1+w*ww;
      a.y(i)=yy/ww;
   end
end

a.y=a.y(:);
a.capt=['lock-in on ' a.capt];
