 function g=gw_pulse1(varargin)
%GW_PULSE	plot of pulse waveforms 	
%
% 			t: time (in s)
%			h: wave amplitude (adimensional)
%
%	keys:
%			'opt': choose one of the following options
%				'drpp': capture of a particle by a black hole - Davis et al. 1971
%				'dus1': dust collapse to b.h., axial emission - Cunningham et al. 1978
%				'dus2': dust collapse to b.h., axial emission - Seidel & Moore 1987
%				'pohp': collapse of a polytropic star core to b.h., axial emission, 
%						  high inner pressure - Seidel 1991
%				'polp': collapse of a polytropic star core to b.h., axial emission,
%						  low inner pressure - Seidel 1991
%				'posb': collapse of a polytropic star core to b.h., axial emission,
%						  ``short'' core bounce - Seidel 1991
%				'polb': collapse of a polytropic star core to b.h., axial emission,
%						  ``long'' core bounce - Seidel 1991
%				'st94': collapse of a rotating polytropic star core to b.h., rotation
%						  parameter a=0.94 - Stark & Piran 1985
%				'st79': collapse of a rotating polytropic star core to b.h., rotation
%						  parameter a=0.79 - Stark & Piran 1985
%
% 			'st': sampling time (in s)
% 			'mass': black hole mass (in solar masses) 
%			'dist': distance of the source (in Mpc)
%			'mpart': mass of the infalling particle (in solar masses) - to be given
%						only for 'drpp'

% Version 1.0 - July 1998/June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
%							 Cristiano Palomba - cristiano.palomba@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

for i = 1:length(varargin)
   strin=varargin{i};
   switch strin
   	case 'opt'
      	op=varargin{i+1};
      case 'st'
         st=varargin{i+1};
      case 'mass'
         ms=varargin{i+1};
      case 'dist'
         r=varargin{i+1};
      case 'mpart'
         mp=varargin{i+1};
   end
end

snag_local_symbols;

str=['load ' snagdir 'gw/gw_pulse/' op]
eval(str)

for i=1:length(t)
    t(i)=t(i)*ms/1.5;
end
t1=(0:t(length(t))/st)*st;
for i=1:length(t)
   if op == 'drpp'
      h(i)=mp/.001*h(i)*(15/r);
   else
      h(i)=(ms/1.5)*h(i)*(15/r);
   end
end   
h1=spline(t,h,t1);

plot(t1,h1,'-')
hold on;
plot(t,h,'*')
xlabel('\it{t}  [s]')
ylabel('\it h')
