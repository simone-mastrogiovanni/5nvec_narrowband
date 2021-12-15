function r_struct=fmnl_open(file,nocont)
%FMNL_OPEN   opens a frame file, reads the file header, finds the fid and format
%
%   Frame Matlab Native Library
%
%      r_struct=fmnl_open(file)
%
%      file      ...
%      nocont    =1 -> no continuous access to files 

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ff={'n' 'b' 'l' 's' 'a' 'g' 'd' 'c'};
%disp('in fmnl_open'),file

for i = 1:8
   [fid message]=fopen(file,'r',ff{i});
   if fid < 0
      disp([file ' <->' message]);
   end
   
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
      if abs((pidobl-3.14159265358979)/3.14159265358979) < 0.001
         r_struct.cont.fid=fid;
         r_struct.cont.file=file;
         if nocont ~= 1
            r_struct=set_cont(r_struct);
         end
         r_struct.cont.fform=ff{i};
         fprintf(' ---> Open file %s \n',file);
      	return
      end
   end
end

disp('Problems in file opening')

igwd,form,vers,minvers,siz_int2,siz_int4,siz_int8,siz_real4,siz_real8
twbyt,fobyt,eibyt,pising,pidobl,az

yn=input('Do you want to open anyway ? (y/n)','s');

if yn == 'y' | yn == 'Y'
   fff=input('Format type ? (n b l s a g d c)','s');
   [fid message]=fopen(file,'r',fff)
   fmnl_read_file_header(fid);
   r_struct.cont.fid=fid;
   r_struct.cont.file=file;
   if nocont ~= 1
      r_struct=set_cont(r_struct);
   end
   r_struct.cont.fform=fff;
   fprintf(' ---> Open file %s \n',file);
   return
end
