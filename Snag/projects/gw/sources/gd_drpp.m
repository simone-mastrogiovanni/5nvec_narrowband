function g=gd_drpp(varargin)
%gd_DRPP  b.h.  Davis,Ruffini,Press & Price 1971
%
% keys :
%
% 'st'    sampling time (in s)
% 'mass'  black hole mass (in solar masses)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n1=128;
a1=zeros(1,n1);

a1(19:30)=[-.05 -.075 -.1 -.125 -.15 -.175 -.2 -.225 -.25 -.275 -.3 -.325];
a1(31:40)=[-.35 -.375 -.4 -.45 -.5 -.55 -.55 -.625 -.65 -.7];
a1(41:50)=[-.7 -.75 -.775 -.8 -.85 -.9 -1. -1.1 -1.15 -1.2];
a1(51:60)=[-1.3 -1.4 -1.5 -1.6 -1.8 -2.0 -2.2 -2.4 -2.6 -2.8];
a1(61:70)=[-2.65 -2.5 -2.15 -1.8 -1.4 -1.0 -.5 0. .75 1.5];
a1(71:80)=[1.95 2.4 2.2 2 1 0 -.35 -.7 -.6 -.5];
a1(81:90)=[-.2 .1 .25 .4 .25 .1 -.075 -.15 -.15 -.15];
a1(91:100)=[-.075 0 .075 .15 .125 .1 0 -.1 -.125 -.15];
a1(101:107)=[-.075 0 .075 .15 .125 .1 .05];

st1=0.00001;
ms=1;
st=st1;

for i = 1:length(varargin)
   strin=varargin{i};
   switch strin
      case 'st'
         st=varargin{i+1};
      case 'mass'
         ms=varargin{i+1};
   end
end

st1=st1*ms;
n=n1*st1/st;
x1=(0:(n1-1))*st1;
x=(0:(n-1))*st;

a=spline(x1,a1,x);

g=gd(a);

g=edit_gd(g,'dx',st,'capt','Davis,Ruffini,Press & Price 1971');

