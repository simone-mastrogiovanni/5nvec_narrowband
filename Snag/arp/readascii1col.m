function a=readascii1col(file,ncomments,ncol,col)
%READASCII1col  reads one column in an ASCII file to a vector
%
%     a=readascii1col(file,ncomments,ncol,col)
%
%   ncomments   is the number of lines containing comments (skipped and displayed)
%   ncol        is the number of the columns of the output array
%               (must be a sub-multiple of the total number of the data)
%   col         number of the output column

[fid,message]=fopen(file,'r');

if fid == -1
   disp(message);
end

for i = 1:ncomments
   line=fgetl(fid);
   disp(line);
end

a=fscanf(fid,'%g');
d=length(a);
nrig=ceil(d/ncol);

a=reshape(a,ncol,nrig);
a=a(col,:);

fclose(fid);