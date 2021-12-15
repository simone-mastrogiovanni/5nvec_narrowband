function [form,fid]=test_snf_format(fid1,file,offset)
%test_snf_format  determines the data coding format
%
%         [form,fid]=test_snf_format(fid1,offset)
%
%         fid     file identifier
%         offset  position on the file
%         form    computer data format ('b' 'l' 's' 'a' 'd' 'g')

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

AI=[1 2 3 4 -1 -2 -3 123];
AR=[3.123456789 -9.87654321 1 -1];
AD=[3.123456789123456 -9.876543e48 1 -1];
A=cat(2,AI,AR,AD)';

fid=fid1;
r_struct.tothlen=offset+128;
fseek(fid,offset,'bof');

[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='n';
   return
end

%-------- 'l' ---------

fclose(fid);
fid=fopen(file,'r','l');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='l';
   return
end

%-------- 'b' ---------

fclose(fid);
fid=fopen(file,'r','b');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A))
if T < 0.000001
   form='b';
   return
end

%-------- 'a' ---------

fclose(fid);
fid=fopen(file,'r','a');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='a';
   return
end

%-------- 's' ---------

fclose(fid);
fid=fopen(file,'r','s');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='s';
   return
end

%-------- 'g' ---------

fclose(fid);
fid=fopen(file,'r','g');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='g';
   return
end

%-------- 'd' ---------

fclose(fid);
fid=fopen(file,'r','d');
fseek(fid,offset,'bof');
[BI,count]=fread(fid,8,'int16');
[BR,count]=fread(fid,4,'float32');
[BD,count]=fread(fid,4,'float64');

B=cat(1,BI,BR,BD);

T=sum(abs((A-B)./A));
if T < 0.000001
   form='d';
   return
end

form='error';
disp(['Error in file decoding :' file]);

