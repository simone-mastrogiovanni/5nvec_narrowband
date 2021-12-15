function r=rg(a)
%RG  rg (ring) class constructor
%
%    r=rg(n,dx)  n is the length of the ring, dx the sampling time
%
%  Data members
%
%    y        the data
%    len      length of the ring
%    indin    input index (last written)
%    indout   output index (last read)
%    totin    total data input
%    totout   total data output
%    ini      beginning of abscissa
%    lastim   last input sample time
%    dx       sampling "time" 
%    capt     caption
%    cont     control variable

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if nargin == 1
   if isa(a,'rg')
      r=a;
   elseif isa(a,'double')
      r.y=zeros(1,a);
      r.len=a;
      r.indin=0;
      r.indout=0;
      r.totin=0;
      r.totout=0;
      r.ini=0;
      r.lastim=0;
      r.dx=1;
      r.capt='no name';
      r.cont=0;
      r=class(r,'rg');
   else
      error('rg class constructor error');
   end
else
   error('rg class constructor error');
end
