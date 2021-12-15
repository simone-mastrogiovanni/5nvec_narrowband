function d=get_rs(r,key)
%GET_RS  gets the parameters of an rs
%
% the first input argument must be an rs
%
%  keys:
%
%    'amp'     amplitudes
%    'fr'      frequencies
%    'ph'      phases
%    'tau'     taus
%    'w'       complex constructors
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

switch key
   case 'amp'
      d=r.amp;
   case 'fr'
      d=r.fr;
   case 'ph'
      d=r.ph;
   case 'tau'
      d=r.tau;
   case 'w'
      d=r.w;
   case 'inp'
      d=r.inp;
   case 'st'
      d=r.st;
   case 'n'
      d=r.n;
   case 'dt'
      d=r.dt;
   case 't'
      d=r.t;
   case 'nst'
      d=r.nst;
   case 'capt'
      d=r.capt;
   case 'cont'
      d=r.cont;
end
