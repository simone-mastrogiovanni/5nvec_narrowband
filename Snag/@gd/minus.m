function a=minus(b,c)
%GD/MINUS minus

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(b,'gd')&isa(c,'gd')
   b=gd(b);
   c=gd(c);
   a=b;
   a.y=b.y-c.y;
   a.capt=strcat(inputname(1),'-',inputname(2));
elseif isa(b,'double')
   c=gd(c);
   a=c;
   a.y=b-c.y;
   if length(b) == 1
      a.capt=strcat(sprintf('%d',b),'-',inputname(2));
   else
      a.capt=strcat(inputname(1),'-',inputname(2));
   end
elseif isa(c,'double')
   b=gd(b);
   a=b;
   a.y=b.y-c;
   if length(c) == 1
      a.capt=strcat(inputname(1),'-',sprintf('%d',c));
   else
      a.capt=strcat(inputname(1),'-',inputname(2));
   end
end

 
