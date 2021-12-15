function [header,field1,field2,field3]=read_r87(fid,reclen)
%READ_R87  reads data in R87 format
%
%       [header,field1,field2,field3]=read_r87(fid,reclen)
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

a=fread(fid,reclen,'int16');

header=read_header_r87(a);

len1=header.len1;
nc1=header.nc1;
len2=header.len2;
nc2=header.nc2;
len3=header.len3;
nc3=header.nc3;

if len1 > 0
   field1=zeros(nc1,len1/nc1);
   bias=a(2);
   for i=1:nc1
      for j=1:len1/nc1
         bias=bias+1;
         switch header.adccode
         case 0
            field1(i,j)=(a(bias)-2024)*0.004883;
         otherwise
            field1(i,j)=a(bias);
         end
      end
   end
else
   field1=zeros(1,1);
end

if len2 > 0
   field2=zeros(nc2,len2/nc2);
   bias=a(2)+len1;
   for i=1:nc2
      for j=1:len2/nc2
         bias=bias+1;
         switch header.adccode
         case 0
            field2(i,j)=(a(bias)-2024)*0.004883;
         otherwise
            field2(i,j)=a(bias)*0.004883;
         end
      end
   end
else
   field2=zeros(1,1);
end

if len3 > 0
   field3=zeros(nc3,len3/nc3);
   bias=a(2)+len1+len2;
   for i=1:nc3
      for j=1:len3/nc3
         bias=bias+1;
         switch header.adccode
         case 0
            field3(i,j)=(a(bias)-2024)*0.004883;
         otherwise
            field3(i,j)=a(bias)*0.004883;
         end
      end
   end
else
   field3=zeros(1,1);
end
