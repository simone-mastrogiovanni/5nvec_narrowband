function [fid,w_struct]=write_snf_header(w_struct)
%write_snf_header      write a SNF file header
%
%       [fid,w_struct]=write_snf_header(w_struct)
%
%    w_struct   write SNF structure

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

format long g;

file=w_struct.file;
obj=w_struct.obj;
nform=w_struct.nform;
compl=' ';
if w_struct.complex == 1
   compl='complex';
end
capt=w_struct.capt;

fid=fopen(file,'w');
nbl=512;
if strcmp(obj,'mds') == 1
   nbl=(w_struct.mds.nch+w_struct.mds.lheadi+w_struct.mds.lheadd+5)*128;
end
blstr=sprintf('%%%ds',nbl);
fprintf(fid,blstr,' ');
fseek(fid,0,'bof');
fprintf(fid,'#SNF#1#snf99|%s|%s|%s| \r\n',obj,nform,compl);
skip=1;
fseek(fid,skip*128,'bof');
fprintf(fid,'#SNF#2# %s \r\n',capt);
skip=2;
fseek(fid,skip*128,'bof');

switch obj
case 'gd'
   name=w_struct.gd.name;
   n=w_struct.gd.n;
   typ=w_struct.gd.type;
   ini=w_struct.gd.ini;
   dx=w_struct.gd.dx;
   fprintf(fid,'#SNF#3# %16s %d %d %g %g \r\n',name,n,typ,ini,dx);
   skip=3;
case 'gd2'
   name=w_struct.gd2.name;
   n=w_struct.gd2.n;
   typ=w_struct.gd2.type;
   ini=w_struct.gd2.ini;
   dx=w_struct.gd2.dx;
   m=w_struct.gd2.m;
   ini2=w_struct.gd2.ini2;
   dx2=w_struct.gd2.dx2;
   fprintf(fid,'#SNF#3# %16s %d %d %g %g %d %g %g \r\n',name,n,typ,ini,dx,m,ini2,dx2);
   skip=3;
case 'ds'
   name=w_struct.ds.name;
   dt=w_struct.ds.dt;
   len=w_struct.ds.len;
   fprintf(fid,'#SNF#3# %16s %d %g \r\n',name,len,dt)
   skip=3;
   w_struct.dtrec=len*dt;
case 'mds'
   for i = 1:w_struct.mds.nch
      name=w_struct.mds.name{i};
      dt=w_struct.mds.dt(i);
      len=w_struct.mds.len(i);
      nform=w_struct.mds.nform{i};
      units=w_struct.mds.units{i};
      fprintf(fid,'#SNF#3# %16s %6s %10s %d %g \r\n',name,nform,units,len,dt)
      skip=skip+1;
      fseek(fid,skip*128,'bof');
   end
   w_struct.dtrec=w_struct.mds.len(1)*w_struct.mds.dt(1);
   lheadi=w_struct.mds.lheadi;
   lheadd=w_struct.mds.lheadd;
   fprintf(fid,'#SNF#4# %d %d \r\n',lheadi,lheadd);
   skip=skip+1;
   fseek(fid,skip*128,'bof');
   
   for i = 1:lheadi
      headname=w_struct.mds.headi.name{i};
      headcapt=w_struct.mds.headi.capt{i};
      fprintf(fid,'#SNF#5# %16s %70s \r\n',headname,headcapt);
      skip=skip+1;
      fseek(fid,skip*128,'bof');
   end
   for i = 1:lheadd
      headname=w_struct.mds.headd.name{i};
      headcapt=w_struct.mds.headd.capt{i};
      fprintf(fid,'#SNF#5# %16s %70s \r\n',headname,headcapt);
      skip=skip+1;
      fseek(fid,skip*128,'bof');
   end
end

if strcmp(nform,'ascii') == 0
   fseek(fid,skip*128,'bof');

   AI=[1 2 3 4 -1 -2 -3 123];
   AR=[3.123456789 -9.87654321 1 -1];
   AD=[3.123456789123456 -9.876543e48 1 -1];

   count=fwrite(fid,AI,'int16');
   count=fwrite(fid,AR,'float32');
   count=fwrite(fid,AD,'float64');
   
   skip=skip+1;
end

fseek(fid,skip*128,'bof');

w_struct.nrec=0;

