function [r,v,tinit]=read_rg(r,n)
%RG/READ_RG   reads n data in a ring
%
%      [r,v,tinit]=read_rg(r,n)
%
%      r      ring
%      n      number of data
%      v      output vector
%      tinit  time of the first sample

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=r.len;
v=(1:n)*0;

if n > len
   disp('rg ERROR: vector too large');
   return
end

if r.totin-r.totout-n < 0
   warning('rg ERROR: too much data requested !');
   return
end

tinit=r.lastim-(r.totin-r.totout-1)*r.dx;

in=r.indout+1;
if in > len
   in=in-len;
end

ic=1;
fin=in+n-1;
if fin > len
   ic=2;
   fin=fin-len;
   n1=n-fin;
end

if ic == 1
   v=r.y(in:fin);
else
   v(1:n1)=r.y(in:len);
   v(n1+1:n)=r.y(1:fin);
end

r.indout=fin;
r.totout=r.totout+n;

