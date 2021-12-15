function [a comm]=readascii_comma(file,ncomments,ncol)
%READASCII_comma  reads an ASCII file to a vector, with comma-to-dot conversion
%
%     a=readascii(file,ncomments,ncol)
%
%   ncomments   is the number of lines containing comments (skipped and displayed)
%   ncol        is the number of the columns of the output array
%               (must be a sub-multiple of the total number of the data)

[fid,message]=fopen(file,'r');

if fid == -1
   disp(message);
end

for i = 1:ncomments
   line=fgetl(fid);
   disp(line);
   comm{i}=line;
end

c=fscanf(fid,'%c');
c=strrep(c,',','.');
a=sscanf(c,' %g');
d=length(a);
nrig=ceil(d/ncol);

a=reshape(a,ncol,nrig);
a=a';

fclose(fid);