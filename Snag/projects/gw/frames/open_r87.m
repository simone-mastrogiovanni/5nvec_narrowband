function [fid,reclen,initime,samptim]=open_r87(file)
%OPEN_R87   opens an R87 file and gives the fid, the record length and the initial time
%
%      [fid,reclen,initime]=open_r87(file)

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(file,'r');

[A,count]=fread(fid,30,'int16');
reclen=A(1);
initime=zeros(1,6);
for i=1:6
   initime(i)=A(12+i);
end
samptim=(A(19)+A(20)*0.001)*0.001;
fclose(fid);

fid=fopen(file,'r');

