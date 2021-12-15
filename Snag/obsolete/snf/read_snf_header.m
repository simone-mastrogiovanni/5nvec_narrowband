function [r_struct,offset]=read_snf_header(fid,r_struct)
%READ_SNF_HEADER  reads SNF file header
%
%   r_struct           read query structure
%
%   offset             file offset after the header

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

file=r_struct.file;

offset=0;
str1=fgetl(fid);
disp(str1);

k=findstr(str1,'#SNF#1#');

if k ~= 1
   disp('Not SNF file; error on #SNF#1# line');
   return
end

caobj={'gd' 'gd2' 'mgd' 'ds' 'mds' 'sfdb' 'ev'};
canform={'ascii' 'int8' 'int16' 'log8' 'log16' 'float'   'double'};
cawform={'ascii' 'int8' 'int16' 'int8' 'int16' 'float32' 'float64'};
adatlen=[0 1 2 1 2 4 8];
caprot={'snf99'};

for i = 1:7
   k=findstr(str1,['|' caobj{i} '|']);
   if isempty(k) == 0
      r_struct.obj=caobj{i};
      break
   end
end

for i = 1:7
   k=findstr(str1,[canform{i} '|']);
   if isempty(k) == 0
      r_struct.nform=canform{i};
      r_struct.wform=cawform{i};
      r_struct.datlen=adatlen(i);
      break
   end
end

for i = 1:length(caprot)
   k=findstr(str1,[caprot{i} '|']);
   if isempty(k) == 0
      r_struct.protocol=caprot{i};
      break
   end
end

r_struct.complex=0;
k=findstr(str1,'complex');
if isempty(k) == 0
   r_struct.complex=1;
end

offset=offset+128;
fseek(fid,offset,'bof');
str2=fgetl(fid);
disp(str2);

k=findstr(str2,'#SNF#2#');
r_struct.capt=str2(8:length(str2));

offset=offset+128;
fseek(fid,offset,'bof');
str3=fgetl(fid);
n3=length(str3)
disp(str3);

k=findstr(str3,'#SNF#3#');

r_struct.absc=0;

switch r_struct.obj
case 'gd'
   name=sscanf(str3(9:24),'%s');
   r_struct.name=name;
   outs=sscanf(str3(25:n3),'%g');
   n=outs(1);typ=outs(2);ini=outs(3);dx=outs(4);
   r_struct.gd.n=n;
   r_struct.n=n;
   r_struct.gd.type=typ;
   r_struct.absc=typ;
   r_struct.gd.ini=ini;
   r_struct.gd.dx=dx;
case 'gd2'
   name=sscanf(str3(9:24),'%s');
   r_struct.name=name;
   outs=sscanf(str3(25:n3),'%g')
   n=outs(1);typ=outs(2);ini=outs(3);dx=outs(4);
   m=outs(5);ini2=outs(6);dx2=outs(7);
   r_struct.gd2.n=n;
   r_struct.n=n;
   r_struct.gd2.type=typ;
   r_struct.absc=typ;
   r_struct.gd2.ini=ini;
   r_struct.gd2.dx=dx;
   r_struct.gd2.m=m;
   r_struct.gd2.ini2=ini2;
   r_struct.gd2.dx2=dx2;
case 'ds'
   name=sscanf(str3(9:24),'%s');
   r_struct.name=name;
   outs=sscanf(str3(25:n3),'%g');
   len=outs(1);dt=outs(2);
   r_struct.ds.len=len;
   r_struct.ds.dt=dt;
   r_struct.reclen=r_struct.datlen*len+12;
case 'mds'
   nch=0;
   drecl=0;
   while str3(1:7) == '#SNF#3#'
      nch=nch+1;
      name=sscanf(str3(9:24),'%s');
      r_struct.mds.name{nch}=name;
      nform=sscanf(str3(26:31),'%s');
      r_struct.mds.nform{nch}=nform;
      wform=nform;
      switch nform
      case 'int8'
         datlen=1;
      case 'int16'
         datlen=2;
      case 'log8'
         wform='uint8';
         datlen=1;
      case 'log16'
         wform='uint16';
         datlen=2;
      case 'float'
         wform='float32';
         datlen=4;
      case 'double'
         wform='float64';
         datlen=8;
      end
      r_struct.mds.wform{nch}=wform;
      r_struct.mds.datlen(nch)=datlen;

      units=sscanf(str3(33:42),'%s');
      r_struct.mds.units{nch}=units;
      outs=sscanf(str3(44:n3),'%g');
      len=outs(1);dt=outs(2);
      r_struct.mds.len(nch)=len;
      r_struct.mds.dt(nch)=dt;
      offset=offset+128;
      fseek(fid,offset,'bof');
      str3=fgetl(fid);
      n3=length(str3)
      disp(str3);
      drecl=drecl+len*datlen+8;
   end
   r_struct.mds.nch=nch;
   bias(1)=0;
   for i = 2:nch
      bias(i)=bias(i-1)+8+r_struct.mds.len(i-1)*r_struct.mds.datlen(i-1);
   end
   
   nsel=length(r_struct.select);
   for i = 1:nsel
      chfound=0;
      for ii = 1:nch
         if strcmp(r_struct.select{i},r_struct.mds.name{ii}) == 1
            chfound=ii;
         end
      end
      if chfound == 0
         disp([r_struct.select{i} ': not found']);
      else
         r_struct.selk(i)=chfound;
         r_struct.selbias(i)=bias(chfound);
      end
   end
   outs=sscanf(str3(9:n3),'%g');
   r_struct.mds.lheadi=outs(1);
   r_struct.mds.lheadd=outs(2);
   nhea=0;
   for i = 1:r_struct.mds.lheadi
      offset=offset+128;
      fseek(fid,offset,'bof');
      str5=fgetl(fid);
      nhea=nhea+1;
      r_struct.mds.headi.name{i}=sscanf(str5(9:24),'%s');
      r_struct.mds.headi.capt{i}=sscanf(str5(26:95),'%s');
   end
   for i = 1:r_struct.mds.lheadd
      offset=offset+128;
      fseek(fid,offset,'bof');
      str5=fgetl(fid);
      nhea=nhea+1;
      r_struct.mds.headd.name{i}=sscanf(str5(9:24),'%s');
      r_struct.mds.headd.capt{i}=sscanf(str5(26:95),'%s');
   end
   r_struct.reclen=drecl+r_struct.mds.lheadi*4+r_struct.mds.lheadd*8;
end

offset=offset+128;
r_struct.tothlen=offset;
