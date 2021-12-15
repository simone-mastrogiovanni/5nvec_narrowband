function [fid,r_struct,varargout]=open_snf_read(r_struct)
%OPEN_SNF_READ  open an snf for read (for ds or mds objects)
%
%        [fid,r_struct,varargout]=open_snf_read(r_struct)
%
%    r_struct          reading structure
%            .file     file name
%            .select   a cell array 

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


file=r_struct.file;
fid=fopen(file,'r');

[r_struct,offset]=read_snf_header(fid,r_struct);

if strcmp(r_struct.obj,'mds') == 1
   [form,fid]=test_snf_format(fid,file,offset);
else
   if strcmp(r_struct.nform,'ascii') == 0
      [form,fid]=test_snf_format(fid,file,offset);
   else
      form='ascii';
   end
end
r_struct.bform=form;
offset=offset+128;

fseek(fid,offset,'bof');

for i = 1:nargout-2 %length(varargout)
   varargout{i}=ds(r_struct.mds.len(i));
end

if nargout > 2
   r_struct.trec=tini1_ds(varargout{i});
end

offset