function [header,data]=read_r87_ch(fid,reclen,ch)
%READ_R87_CH  reads data in R87 format for channel number ch
%
%       [header,data]=read_r87_ch(fid,reclen,ch)
%
% the file must be opened by open_r87
%
%     header   is a structure with
%       header.time   time of the first sample of each field (in MJD)
%       header.st     sampling time (in seconds)
%       header.len1   length of field 1
%       header.nc1    number of channels in field 1
%       header.len2   length of field 2
%       header.nc2    number of channels in field 2
%       header.len3   length of field 3
%       header.nc3    number of channels in field 3
%     fieldx   are matrices with the data

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

chfield=floor(ch/100);
chan=ch-chfield*100;
a=zeros(1:6);

while a(6) ~= 1
   a=fread(fid,reclen,'int16');
end

header=read_header_r87(a);

len1=header.len1;
nc1=header.nc1;
len2=header.len2;
nc2=header.nc2;
len3=header.len3;
nc3=header.nc3;

switch chfield
case 1
   len=len1;nc=nc1;bias=header.headlen+chan;
case 2
   len=len2;nc=nc2;bias=header.headlen+len1+chan;
case 3
   len=len3;nc=nc3;bias=header.headlen+len1+len2+chan;
end

stcor=(nc*len1)/(nc1*len);
header.st=header.st*stcor;

data=zeros(1,len/nc);

for i=1:len/nc
   switch header.adccode
   case 0
      data(i)=(a(bias)-2024)*0.004883;
   otherwise
      data(i)=a(bias)*0.004883;
   end
   bias=bias+nc;
end
