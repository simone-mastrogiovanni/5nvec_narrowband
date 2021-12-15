function r_struct=set_cont(r_struct)
%SET_CONT   sets the elements of r_struct for continuos reading
%
%        r_struct=set_cont(r_struct)
%
%   r_struct.cont.file       starting file name (with directory)
%           .cont.files0     files0 file (list of files in the directory)
%           .cont.files1     more advanced db file
%           .cont.dir        directory
%           .cont.fid        fid
%           .cont.files{k}   list of files (without directories)
%           .cont.k          actual serial number of the file
%           .cont.kmax       total number of files in the directory
%           .cont.eofs       on 1, end of files
%           .cont.time1      start time (mjd)
%           .cont.time2      stop time (mjd)
%           .cont.nocont     =1 no continuous access

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


r_struct.cont.eofs=0;
file=r_struct.cont.file;

ii=max(findstr(file,filesep));

if isempty(ii)
   ii=max(findstr(file,'/'));
end

r_struct.cont.dir=file(1:ii);
r_struct.cont.files0=[r_struct.cont.dir 'fmnl_files0.dat'];

fil=file(ii+1:length(file));

[fid0,message]=fopen(r_struct.cont.files0);

if fid0 < 0
   disp(message);
   r_struct.cont.files{1}=deblank(fil);
   r_struct.cont.k=1;
   r_struct.cont.kmax=1;
   return
end

eof=0;
i=0;

while 1
   eof=feof(fid0);
   i=i+1;
   str=fgetl(fid0);
   str=deblank(str);
   r_struct.cont.files{i}=str;
   
   if strcmp(str,fil)
      r_struct.cont.k=i;
   end
   
   if eof == 1
      fclose(fid0);
      break
   end
end

r_struct.cont.kmax=i;
