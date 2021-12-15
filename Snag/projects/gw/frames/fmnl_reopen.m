function r_struct=fmnl_reopen(r_struct)
%FMNL_REOPEN   opens a new frame file, reads the file header
%
%   Frame Matlab Native Library
%
%      r_struct=fmnl_reopen(r_struct)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

k=r_struct.cont.k+1;

if k > r_struct.cont.kmax
   r_struct.cont.eofs=1;
   disp(' *** End of files !');
   return
end

file=r_struct.cont.files{k};

ff=r_struct.cont.fform;file,ff,k,r_struct.cont.files

fid=fopen(file,'r',ff);fid
r_struct.cont.fid=fid;
   
igwd=fread(fid,4,'char');igwd=char(igwd);

form=fread(fid,1,'uchar');
vers=fread(fid,1,'uchar');
minvers=fread(fid,1,'uchar');
siz_int2=fread(fid,1,'uchar');
siz_int4=fread(fid,1,'uchar');
siz_int8=fread(fid,1,'uchar');
siz_real4=fread(fid,1,'uchar');
siz_real8=fread(fid,1,'uchar');

twbyt=fread(fid,1,'uint16');
fobyt=fread(fid,1,'uint32');
eibyt=fread(fid,1,'uint64');

pising=fread(fid,1,'float32');
pidobl=fread(fid,1,'float64');

az=fread(fid,2,'char');az=char(az);
   
if pising ~= 0
	if abs(pidobl-3.14159265358979) < 0.000001
   	r_struct.cont.fid=fid;
      r_struct.cont.file=file;
      r_struct=set_cont(r_struct);
      r_struct.cont.k=k;
 %     r_struct.cont.fform=ff;
      fprintf(' ---> Open file %s \n',file)
      return
   end
end

disp('Problems in file opening')
igwd,form,vers,minvers,siz_int2,siz_int4,siz_int8,siz_real4,siz_real8
twbyt,fobyt,eibyt,pising,pidobl,az