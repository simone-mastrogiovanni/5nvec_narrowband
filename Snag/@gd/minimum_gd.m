function a=minimum_gd(b,c)
%GD/MINIMUM_GD  minumum

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(b,'gd')&isa(c,'gd')
   b=gd(b);
   c=gd(c);
   a=b;
   a.y=min(b.y,c.y);
   a.capt=['Minimum ',inputname(1),' ',inputname(2)];
elseif isa(b,'double')
   c=gd(c);
   a=c;
   a.y=min(b,c.y);
   if length(b) == 1
      a.capt=[sprintf('Minimum %d',b),' ',inputname(2)];
   else
      a.capt=['Minimum ' inputname(1),' ',inputname(2)];
   end
elseif isa(c,'double')
   b=gd(b);
   a=b;
   a.y=min(b.y,c);
   if length(c) == 1
      a.capt=['Minimum ' inputname(1),' ',sprintf('%d',c)];
   else
      a.capt=['Minimum ' inputname(1),' ',inputname(2)];
   end
end

 
