function struct_num=fmnl_dict(file)
%FMNL_DICT  creates dictionary
%
%       struct_num=fmnl_dict(file)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

strnam{1}='FrameH ';
strnam{2}='FrAdcData ';
strnam{3}='FrDetector ';
strnam{4}='FrEndOfFrame ';
strnam{5}='FrMsg ';
strnam{6}='FrHistory ';
strnam{7}='FrRawData ';
strnam{8}='FrProcData ';
strnam{9}='FrSimData ';
strnam{10}='FrSerData ';
strnam{11}='FrStatData ';
strnam{12}='FrVect ';
strnam{13}='FrTrigData ';
strnam{14}='FrSummary ';
strnam{15}='FrEndOfFile ';
strnam{16}='FrFileMark ';
nstrnam=16;
strnum=zeros(nstrnam,1);
struct_num=strnum';

r_struct=fmnl_open(file,1);
fid=r_struct.cont.fid;

pos=ftell(fid);

fst_typ=0;
%types=sparse(100000,1);
dummy=zeros(16,1);

while fst_typ ~= -4
   fst=fmnl_read_struct(fid,dummy);
   if fst.len <= 0
      disp('Error: structure length = 0');
      disp(fst);
      break;
   end
   fst_typ=fst.classtype;
%   types(fst_typ)=types(fst_typ)+1;
   if fst_typ == 1
      ind=strcmp(deblank(fst.name),deblank(strnam));
      struct_num(find(ind))=fst.class;
   end
end

fclose(fid);