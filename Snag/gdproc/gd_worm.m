function g=gd_worm(varargin)
%ANALYSIS\GD_WORM  worm analysis
%
%  first argument the imput gd
%
%  keys:
%
%   'freq'   frequency
%   'tau'    inserts a 0-phase band-pass with that tau
%   'Q'      inserts a 0-phase band-pass with that Q
%   'wtau'   worm tau (not yet operative)
%   'icshow' shows the worm
%
%  example:  cg=gd_worm(g,'freq',200)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=varargin{1};
icshow=0;

fr=1;
tau=0;
if ~exist('Q')
    Q=0;
end

for i = 1:length(varargin)
   str=varargin{i};
   if isa(str,'char')
      switch str
      case 'freq'
         fr=varargin{i+1};
      case 'tau'
         tau=varargin{i+1};
      case 'wtau'
         wtau=varargin{i+1};
      case 'icshow'
         icshow=1;
      end
   end
end

if nargin == 1
    prompt={'Frequency','Band-pass Q (0 -> no b.p.)','Worm tau','icshow'};
    answ=inputdlg(prompt,'Worm psrsmeters',1,{'1' '0' '0' '1'});
    fr=eval(answ{1});
    Q=eval(answ{2});
    wtau=eval(answ{3});
    icshow=eval(answ{4});
end

if Q > 0
    tau=Q/(pi*fr);
end

g=gd(a);

dt=dx_gd(a);
x=x_gd(a);
y=y_gd(a);
if isreal(y)
    notreal=0;
else
    notreal=1;
    yi=imag(y);
end
y=real(y);
pi2=2*pi;
x=mod(x.*(pi2*fr),pi2);

if tau > 0
    amf=crea_am('band-pass',fr*dt,tau/dt);
    amf.bilat=1;
    y=am_filter(y,amf);
    if notreal == 1
        yi=am_filter(yi,amf);
    end
end

w=1;
if exist('wtau') & wtau > 0
    w=exp(-dt/wtau);
end
% wtau,dt,w

y=y.*exp(j.*x);
if notreal == 1
    yi=yi.*exp(j.*x);
end

if w == 1
    y=cumsum(y);
else
    y=filter(1,[1 -w],y);
end

if notreal == 1
    if w == 1
        yi=cumsum(yi);
    else
        yi=filter(1,[1 -w],yi);
    end
    y=y+yi;
end

g=edit_gd(g,'capt',strcat('worm of ',inputname(1)),'y',y,'addcapt','worm on:');

if icshow > 0
    figure,plot(y),grid on,hold on
    set(gca,'DataAspectRatio',[1.1 1.1 1],...
            'PlotBoxAspectRatio',[1 1 1])
    plot([0 0],[0 0],'r.')
end