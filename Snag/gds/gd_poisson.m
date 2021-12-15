function g=gd_poisson(param)
%GD/GD_POISSON   Poisson processes
%
%      g=gd_poisson(param)
%       or
%      g=gd_poisson
%
%   param(1)   lambda
%   param(2)   mode (1 time series, 2 only events)
%   param(3)   time observation interval
%   param(4)   sampling time (for mode 1)
%   param(5)   amplitude

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('param')
   promptcg1={'Lambda ? (density)' 'Mode ? (1 time series, 2 only events)'...
      'Time interval' 'Sampling time (for mode 1)' 'Amplitude'};
	defacg1={'0.01' '1' '1000' '0.1' '1'};
	answ=inputdlg(promptcg1,'Poisson process parameters',1,defacg1);

	param(1)=eval(answ{1});
	param(2)=eval(answ{2});
	param(3)=eval(answ{3});
	param(4)=eval(answ{4});
	param(5)=eval(answ{5});
end

lam=param(1);
mode=param(2);
toss=param(3);
dt=param(4);
amp=param(5);

switch mode
case 1
   n=ceil(toss/dt);
   nev=ceil(toss*lam);
   y=zeros(n,1);
   ev=floor(rand(nev,1).*n)+1;
   
   for i = 1:nev
      y(ev(i))=y(ev(i))+amp;
   end
   
   g=gd(y);
   g=edit_gd(g,'dx',dt,'capt','Posson process');
case 2
   nev=ceil(toss*lam);
   ev=rand(nev,1).*toss;
   ev=sort(ev);
   y=ones(nev,1).*amp;
   g=gd(y(:));
   g=edit_gd(g,'type',2,'x',ev(:));
end
