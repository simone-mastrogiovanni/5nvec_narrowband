function gout=gd_acorfft(varargin)
%GD_ACORFFT  autocorrelation or autocovariance based on fft
%
% gd must have length a power of 2
%
% First argument: input gd
%
%   keys :
%
%   'covar'   autocovariance
%   'norm'    normalized
%   'nozero'  excludes the (2*n-1) values around zero zero; followed by n 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=varargin{1};
y=y_gd(gout);

icov=0;
inorm=0;
nzero=0;
addc='autocorrelation on :';

for i = 2:length(varargin)
   str=varargin{i};
   switch str
   case 'covar'
      icov=1;
      addc='autocovariance on :';
   case 'norm'
      inorm=1;
   case 'nozero'
      nzero=varargin{i+1};
   end
end

y=fft(y);

y=y.*conj(y);

if icov == 1
   y(1)=0;
end

y=ifft(y)/length(y);
rot=length(y)/2;
y=rota(y,rot);
dx=dx_gd(gout);
% ini=-(rot+1)*dx;
ini=-rot*dx;

if inorm == 1
   y=y./y(rot+1);
end

yz=y(rot+1+nzero);

for i = 1:nzero
   y(rot+i)=yz;
   y(rot+2-i)=yz;
end

gout=edit_gd(gout,'y',y,'ini',ini,'addcapt',addc);