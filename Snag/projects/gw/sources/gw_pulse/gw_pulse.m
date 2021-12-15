 function g=gw_pulse(varargin)
%GW_PULSE	pulse waveforms (on GD)  	
%
%			gwp_pulse(...)
%	keys:
%			'opt': choose one of the following options
%				'gwp_drpp': capture of a particle by a black hole - Davis et al. 1971
%				'gwp_dus1': dust collapse to b.h., axial emission - Cunningham et al. 1978
%				'gwp_dus2': dust collapse to b.h., axial emission - Seidel & Moore 1987
%				'gwp_pohp': collapse of a polytropic star core to b.h., axial emission, 
%						  high inner pressure - Seidel 1991
%				'gwp_polp': collapse of a polytropic star core to b.h., axial emission,
%						  low inner pressure - Seidel 1991
%				'gwp_posb': collapse of a polytropic star core to b.h., axial emission,
%						  ``short'' core bounce - Seidel 1991
%				'gwp_polb': collapse of a polytropic star core to b.h., axial emission,
%						  ``long'' core bounce - Seidel 1991
%				'gwp_st94': collapse of a rotating polytropic star core to b.h., rotation
%						  parameter a=0.94 - Stark & Piran 1985
%				'gwp_st79': collapse of a rotating polytropic star core to b.h., rotation
%						  parameter a=0.79 - Stark & Piran 1985
%
% 			'st': sampling time (in s)
% 			'mass': black hole mass (in solar masses) 
%			'dist': distance of the source (in Mpc)
%			'mpart': mass of the infalling particle (in solar masses) - to be given
%						only for 'gwp_drpp'
%        'show':  plots the data
%
%		output:
% 			abscissa: time (in s)
%			ordinate: wave amplitude (adimensional)

% Version 1.0 - July 1998/June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
%	 Cristiano Palomba - cristiano.palomba@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

op='gwp_dus1';
st=1e-6;
ms=1.5;
r=15;
icsh=0;

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
      case 'show'
         icsh=1;
   end
end
                                                               
snag_local_symbols;
str=['cd ' snagdir 'projects\gw\sources\gw_pulse\'];
eval(str);

if op == '?'
   str={'Capture of a particle by a black-hole' ...
      'Dust collapse to a black-hole (1)' ...
      'Dust collapse to a black-hole (2)' ...
      'Polytropic collapse (high pressure)' ...
      'Polytropic collapse (low pressure)' ...
      'Polytropic collapse (long bounce)'...
      'Polytropic collapse (short bounce)'...
      'Rotating polytropic collapse (a=0.79)' ...
   	'Rotating polytropic collapse (a=0.94)'};

[ptype iok]=listdlg('PromptString','Select a process:',...
      'Name','Gravitational pulse signals',...
   	'ListSize',[300 300],...
   	'SelectionMode','single',...
   	'ListString',str);

	switch ptype
	case 1
   	op='gwp_drpp';
	case 2
   	op='gwp_dus1';
	case 3
   	op='gwp_dus2';
	case 4
   	op='gwp_pohp';
	case 5
   	op='gwp_polp';
	case 6
   	op='gwp_polb';
	case 7
   	op='gwp_posb';
	case 8
   	op='gwp_st79';
	case 9
   	op='gwp_st94';
   end
end

eval(op);
for i=1:length(t)
    t(i)=t(i)*ms/1.5;
end
t1=(0:t(length(t))/st)*st;
for i=1:length(t)
   if op == 'gwp_drpp'
      h(i)=mp/.001*h(i)*(15/r);
   else
      h(i)=(ms/1.5)*h(i)*(15/r);
   end
end   
h1=spline(t,h,t1);

g=gd(h1);
g=edit_gd(g,'dx',st,'capt','pulse');

if icsh == 1
   figure
   plot(t1,h1,'-')
	hold on;grid on;
	plot(t,h,'*')
	xlabel('\it{t}  [s]')
   ylabel('\it h')
   zoom on
end

msgbox(msg)
