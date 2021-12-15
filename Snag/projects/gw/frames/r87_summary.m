function [strout,dt]=r87_summary(ic)
%R87_SUMMARY   summary for R87 files
%
%        [strout,dt]=r87_summary(ic)
%
%        ic = 0   full output
%        ic = 1   holes
%        ic = 2   just start and stop
%
%        strout   output string
%        dt       time error vector

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ic == 1
   thr=input('minimum delay for a hole ?  ');
end

snag_local_symbols;

file=selfile(rogdata);

[fid,reclen,initime,samptim]=open_r87(file);
header=read_r87_noout(fid,reclen);

while header.type ~= 1
   header=read_r87_noout(fid,reclen);
end

str0=sprintf(' st=%f  ch: %d %d %d',header.st,header.nc1,header.nc2,header.nc3);

t=header.time;
str1=mjd2s(t);
i=0;

while header.len > 0
   str2=mjd2s(t);
   header=read_r87_noout(fid,reclen);
   if header.len > 0
      t1=t+(header.st*header.len1/header.nc1)/86400;
      t=header.time;
      s=mjd2s(t);
      i=i+1;
      dt(i)=(t-t1)*86400;
      switch ic
      case 0
         fprintf(' %d -> %s  err=%f \n',header.recnum,s,dt(i));
      case 1
         if abs(dt(i)) > thr
            fprintf(' %d -> %s  err=%f \n',header.recnum,s,dt(i));
         end
      end
   end
end

strout=[file ' > ' str1 ' <-> ' str2 str0];
