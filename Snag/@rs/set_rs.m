function r=set_rs(varargin)
%RS/SET_RS  sets the parameters of an rs
%
% the first input argument must be an rs
%
%  keys:
%
%    'amp'     amplitudes
%    'fr'      frequencies
%    'ph'      phases
%    'tau'     taus
%    'w'       complex constructors ; normally not set
%    'inp'     complex inputs
%    'st'      complex status
%    'n'       number of resonances
%    
%    'dt'      sampling time
%    't'       time
%    'nst'     number of steps
%    'capt'    caption
%    'cont'    control variable

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

r=varargin{1};
icw=0;

for i = 2:2:length(varargin)
   str=varargin{i};
   switch str;
   case 'amp'
      r.amp=varargin{i+1};
   case 'fr'
      r.fr=varargin{i+1};
   case 'ph'
      r.ph=varargin{i+1};
   case 'tau'
      r.tau=varargin{i+1};
   case 'w'
      r.w=varargin{i+1};
      icw=1;
   case 'inp'
      r.inp=varargin{i+1};
   case 'st'
      r.st=varargin{i+1};
   case 'n'
      r.n=varargin{i+1};
   case 'dt'
      r.dt=varargin{i+1};
   case 't'
      r.t=varargin{i+1};
   case 'nst'
      r.nst=varargin{i+1};
   case 'capt'
      r.capt=varargin{i+1};
   case 'cont'
      r.cont=varargin{i+1};
   end
end

if icw == 0
   j2pi=j*2*pi;
   r.w=exp(j2pi.*r.dt.*r.fr-r.dt./r.tau);
end
