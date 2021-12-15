function g=o2proc_gd(n,dt,fr,Q,typ,stdev)
%O1PROC_GD   order 1 stochastic process
%
%       g=o2proc_gd(n,dt,fr,Q,typ)
%        or
%       g=o2proc_gd
%
%     typ = 0      input randn
%         = 1        "   delta
%         array x    "   array x

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('typ')
    typ=0;
end

if ~exist('stdev')
    stdev=1;
end

if nargin < 3
   prompt={'Length' 'Sampling time' 'Resonance frequency' 'Q' 'St.Dev.'};
   defarg={'10000' '1' '0.1' '20' '1'};
   
   answ=inputdlg(prompt,'Parameters of the first order process',...
      1,defarg);
   n=eval(answ{1});
   dt=eval(answ{2});
   fr=eval(answ{3});
   Q=eval(answ{4});
   stdev=eval(answ{5});
end

tau=Q/(pi*fr);
w=exp(-dt/tau);
w1=-2*w*cos(2*pi*fr*dt);
w2=w^2;
a=[1 w1 w2];
b=1;
if typ == 0
    y=filter(b,a,randn(n,1));
else
    if length(typ) > 1
        y=filter(b,a,typ);
    else
        x=zeros(n,1);
        x(1)=1;
        y=filter(b,a,x);
    end
end
y=y(:);
sd=std(y);
y=y*stdev/sd;

g=gd(y);
g=edit_gd(g,'dx',dt,'capt','Second order process');