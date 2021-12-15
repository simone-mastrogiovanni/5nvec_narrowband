function powsout=ipows_ds_ng(varargin)
%IPOWS_DS  computes power spectra of a ds, no graph
%
%  outputs a power spectrum (no graphics)
%
%  first input :   a ds
%  second input:   answ, a cell array, not initiated
%
%  keys:
%
%   'interact' interactive setting: some settings mean default 
%
%   'nwindow'  no window
%   'bwindow'  Bartlett window
%   'hwindow'  Hanning window
%
%   'limit'    limits on the frequency axis; followed by the indexes n1,n2
%   'logy'     semilog y
%   'loglog'   
%   'sqrt'     square root of the power spectrum

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};
answ=varargin{2};

kds=d.lcw;
dt=d.dt;
len=d.len;
n1=0;
n2=len/2;
%ind1=1;
%ind2=len;

%icint=0;

%ichist1=0;
%iclog1=0;
%icsqrt1=0;
%tau1=6;
icwind=2;

for i = 4:length(varargin)
   str=varargin{i};
   switch str
%   case 'interact'
%      icint=1;
%   case 'single'
%      ichist1=0;
%   case 'total'
%      ichist1=1;
%   case 'ar'
%      ichist1=2;
%      tau1=varargin{i+1};
%   case 'dar'
%      ichist1=3;
%      tau1=varargin{i+1};
   case 'limit'
      n1=varargin{i+1};
      n2=varargin{i+2};
%   case 'logy'
%      iclog1=1;
%   case 'loglog'
%      iclog1=2;
%   case 'sqrt'
%      icsqrt1=1;
   case 'nwindow'
      icwind=0;
   case 'bwindow'
      icwind=1;
   case 'hwindow'
      icwind=2;
   end
end

if kds == d.nc1
   y=d.y1(1:d.len);
else
   y=d.y2;
end

if icwind == 1
   y=y.*pswindow('bartlett',length(y));
elseif icwind == 2
   y=y.*pswindow('hanning',length(y));
end

powsout=abs(fft(y)).^2/len;
powsout=powsout(n1:n2);

