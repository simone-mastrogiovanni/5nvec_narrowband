function a=thresh(b,t1,t2)
%THRESH  threshold function (0 if out, 1 if in)
%          a=thresh(b,t1,t2)
%  if t1 < t2  in is in the interval, else it is out

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if t1 < t2 
   a1=floor((sign(b-t1)+2)/2);
   a=a1.*floor((sign(t2-b)+2)/2);
else
   a1=floor((sign(t2-b)+1)/2);
   a=a1+floor((sign(b-t1)+1)/2);
end

