function g=o1proc_gd(n,dt,tau,stdev)
%O1PROC_GD   order 1 stochastic process
%
%       g=o1proc_gd(n,dt,tau)
%        or
%       g=o1proc_gd

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if nargin < 3
   prompt={'Length' 'Sampling time' 'Tau' 'St.Dev.'};
   defarg={'10000' '1' '100' '1'};
   
   answ=inputdlg(prompt,'Parameters of the first order process',...
      1,defarg);
   n=eval(answ{1});
   dt=eval(answ{2});
   tau=eval(answ{3});
   stdev=eval(answ{4});
end

if ~exist('stdev')
    stdev=1;
end

w=exp(-dt/tau);
a=[1 -w];
b=1;
y=filter(b,a,randn(n,1));
y=y(:);
y=y*stdev/std(y);

g=gd(y);
g=edit_gd(g,'dx',dt,'capt','First order process');