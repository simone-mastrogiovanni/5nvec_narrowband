function r=write_rg(r,v,lastim)
%RG/WRITE_RG   writes in a ring
%
%      r=write_rg(r,v,lastim)
%
%      r       ring
%      v       vector to be written
%      lastim  time of the last sample

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(v);
len=r.len;

if n > len
   disp('ERROR: vector too large');
   return
end

in=r.indin+1;
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
   r.y(in:fin)=v;
else
   r.y(in:len)=v(1:n1);
   r.y(1:fin)=v(n1+1:n);
end

r.indin=fin;
r.totin=r.totin+n;
r.lastim=lastim;
%r.totin,r.totout

if r.totin-r.totout > len
   warning('rg data lost !');
end

