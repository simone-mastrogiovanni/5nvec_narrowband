function a=readascii(file,ncomments,ncol)
%READASCII  reads an ASCII file to a vector
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
end

a=fscanf(fid,' %g');
d=length(a);
nrig=ceil(d/ncol);

a=reshape(a,ncol,nrig);
a=a';

fclose(fid);