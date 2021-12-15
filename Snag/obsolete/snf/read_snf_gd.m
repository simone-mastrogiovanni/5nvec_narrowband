function [g,r_struct]=read_snf_gd(r_struct)
%READ_SNF  reads a file in SNF format, for gd and gd2 objects
%
%          [g,r_struct]=read_snf_gd(r_struct)
%
%   g            output (a gd or else, dependic of r_struct and the data)
% 
%   r_struct           read/write operative structure 
%                      (for gd, gd2 and ds, only .file is necessary to read, 
%                       .file and .nform to write; the other fields are 
%                       automatically set)
%  1(0)     .protocol  the protocol (in future may be more than one)
%  0        .verbose   verbosity level (normally 1, may be set 0 or 2 or ...)
%  0        .file      input file
%  10       .nform     numerical format 
%                      ('ascii' 'int8' 'int16' 'log8' 'log16' 'float' 'double')
%  1        .wform     numerical format 
%                      ('ascii' 'int8' 'int16' 'uint8' 'uint16' 'float32' 'float64')
%  1        .obj       object ('gd' 'gd2' 'mgd' 'ds' 'mds' 'sfdb' 'ev')
%  1        .complex   =1 for complex data
%  1(0)     .capt      caption
%  1        .n         number of data (only for gd and gd2)
%  1        .absc      =1 virtual abscissa, =2 real abscissa
%                      (only for gd and gd2)
%  0        .xunit     abscissa unit (optional; may be 'seconds', 'mjd', 'Hz')
%  2        .nrec      number of the record
%  2        .trec      record time (typically in mjd)
%  1        .dtrec     time duration of a record (typically in sec)
% gd
%  1        .gd.name
%  1        .gd.n
%  1        .gd.type
%  1        .gd.ini
%  1        .gd.dx
% gd2
%  1        .gd2.name
%  1        .gd2.n
%  1        .gd2.type
%  1        .gd2.ini
%  1        .gd2.dx
%  1        .gd2.m
%  1        .gd2.ini2
%  1        .gd2.dx2
% ds
%  1        .ds.name
%  1        .ds.dt
%  1        .ds.len
%  2        .ds.ini
% mds
%  10       .mds.nch       number of channels
%  1        .mds.recl      record length (in bytes)
%  2        .mds.ini       init time for the record
%  3        .mds.del(k)    delay, for each channel, to be added to the 
%                          init time
%  10       .mds.name(k)
%  10       .mds.nform(k)
%  10       .mds.units(k)  data units ('volt', 'K', ...)
%  1        .mds.wform(k)
%  10       .mds.len(k)
%  10       .mds.dt(k)
%  10       .mds.lheadi
%  10       .mds.lheadd
%  10       .mds.headi.name(k)
%  10       .mds.headi.capt(k)
%  2        .mds.headi.val(k)
%  10       .mds.headd.name(k)
%  10       .mds.headd.capt(k)
%  2        .mds.headd.val(k)
% 
% cont  ! For continuos reading; used also by other libraries (fmnl, r87,...)
%               (see in set_cont)
%           .cont.file       starting file name (with directory)
%           .cont.file0      file0 file (list of files in the directory)
%           .cont.file1      more advanced db file
%           .cont.dir        directory
%           .cont.fid        fid
%           .cont.files{k}   list of files (without directories)
%           .cont.k          actual serial number of the file
%           .cont.kmax       total number of files in the directory
%
%  Other uses:
%
%           .struct_num      frames structure number
%
% The numbers (0,1,2,3) have the following meaning:
%
%    0    external - set by the user before the call
%    1    file header - set by the the read or write header processor
%         (level of #SNF# lines); constant for the whole file
%    2    record header - set by the read or write record processor
%         (level of record header or ds time)
%    3    field header - set by the read or write field processor
%         (level of fields: mds channels time);
%
% 10 means 0 to write and 1 to read.
%
%

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

file=r_struct.file;
fid=fopen(file,'r');

[r_struct,offset]=read_snf_header(fid,r_struct);

wform=r_struct.wform;
nform=r_struct.nform;

if strcmp(wform,'ascii') == 0
   [form,fid]=test_snf_format(fid,file,offset);
   r_struct.bform=form;
   offset=offset+128;
end

fseek(fid,offset,'bof');

if strcmp(wform,'ascii') == 1
   if r_struct.absc == 2
      [x,count]=fscanf(fid,'%g',r_struct.n);
   end
   [y,count]=fscanf(fid,'%g');
else
   if r_struct.absc == 2
      [x,count]=fread(fid,r_struct.n,'float32');
   end
   [y,count]=fread(fid,inf,wform);
end

out=sprintf('  %d data read',count);disp(out);

switch r_struct.obj
case 'gd'
   g=gd(y);
   g=edit_gd(g,'dx',r_struct.gd.dx,'ini',r_struct.gd.ini,...
      'capt',r_struct.capt,'type',r_struct.gd.type);
   if r_struct.absc == 2
      g=edit_gd(g,'x',x);
   end
case 'gd2'
   g=gd2(y);
   g=edit_gd2(g,'dx',r_struct.gd2.dx,'ini',r_struct.gd2.ini,...
      'capt',r_struct.capt,'type',r_struct.gd2.type,...
      'dx2',r_struct.gd2.dx2,'ini2',r_struct.gd2.ini2,'m',r_struct.gd2.m);
   if r_struct.absc == 2
      g=edit_gd(g,'x',x);
   end
end

fclose(fid);
