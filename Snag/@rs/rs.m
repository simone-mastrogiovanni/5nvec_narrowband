function r=rs(a)
%RS rs (resonance) class constructor
%
% if a is a double, it is the number of resonances
%
%  Data members
%
%    amp     amplitudes
%    fr      frequencies
%    ph      phases
%    tau     taus
%    w       complex constructors
%    inp     complex inputs
%    st      complex status
%    n       number of resonances
%    
%    dt      sampling time
%    t       time
%    nst     number of steps
%    capt    caption
%    cont    control variable

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if nargin == 0
   aa=1;
   r.amp=ones(1,aa);
   r.fr=zeros(1,aa);
   r.ph=zeros(1,aa);
   r.tau=zeros(1,aa);
   r.w=ones(1,aa)+j.*zeros(1,aa);
   r.inp=zeros(1,aa)+j.*zeros(1,aa);
   r.st=zeros(1,aa)+j.*zeros(1,aa);
   r.n=aa;
   r.dt=1;
   r.t=0;
   r.nst=0;
   r.capt='resonances';
   r.cont=0;
   r=class(r,'rs');
elseif isa(a,'double')
   r.amp=ones(1,a);
   r.fr=zeros(1,a);
   r.ph=zeros(1,a);
   r.tau=zeros(1,a);
   r.w=ones(1,a)+j.*zeros(1,a);
   r.inp=zeros(1,a)+j.*zeros(1,a);
   r.st=zeros(1,a)+j.*zeros(1,a);
   r.n=a;
   r.dt=1;
   r.t=0;
   r.nst=0;
   r.capt='resonances';
   r.cont=0;
   r=class(r,'rs');
elseif isa(a,'rs')
   r=a;
   r.st=zeros(1,a)+j.*zeros(1,a);
   r.t=0;
   r.nst=0;
   r.cont=0;
else
   error('rs class constructor error');
end
