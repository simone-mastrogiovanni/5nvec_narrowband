function g=gd_pol(varargin)
%GD_POL  polinomial signal
%
%  keys:
%   'coef'    coefficients of the powers (starting from x^0 to x^n)
%   'len'     length (number of values)
%   'dt'      sampling time

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

coef=[0 0 1];
len=1000;
dt=1;

for i = 1:2:length(varargin)
   str=varargin{i};
   switch str
   case 'coef'
      coef=varargin{i+1};
   case 'len'
      len=varargin{i+1};
   case 'dt'
      dt=varargin{i+1};
   end
end

x=(0:(len-1))*dt;
n=length(coef);

y=ones(1,len).*coef(1);

for i=2:n
   y=y+coef(i).*x.^(i-1);
end

g=gd(y);

g=edit_gd(g,'capt','polinomial','dx',dt);