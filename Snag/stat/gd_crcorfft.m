function gout=gd_crcorfft(varargin)
%GD_CRCORFFT  crosscorrelation or crosscovariance based on fft
%
% First two arguments: input gds
%
%   keys :
%
%   'covar'   autocovariance
%   'norm'    normalized

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

gout=varargin{1};
y=y_gd(gout);
y1=y_gd(varargin{2});
ss1=std(y)*std(y1);
n=length(y);
n1=length(y1);
nn=max(n,n1)*2;
nn2=nn/2;
y(n+1:nn)=0;
y1(n1+1:nn)=0;

icov=0;
inorm=0;

for i = 3:length(varargin)
   str=varargin{i};
   switch str
   case 'covar'
      icov=1;
   case 'norm'
      inorm=1;
   end
end

y=fft(y);
y1=fft(y1);

y=y.*conj(y1);

if icov == 1
   y(1)=0;
end

y=real(ifft(y));
y=rota(y,nn2);
dx=dx_gd(gout);
ini=-nn2*dx;

if inorm == 1
   y=y./(nn*ss1/2);
end

gout=edit_gd(gout,'y',y,'ini',ini,'type',1,'n',nn,'addcapt','xcorr on');nn