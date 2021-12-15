function text=r_s_show(r_struct)
%R_S_STRUCT   shows an r_struct
%
%           text=r_s_show(r_struct)

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

text1=sprintf(['\n           SNF Read/Write Structure \n\n' ...
   'The file %s contains a %s object \n' ...
   '  protocol is %s \n\n'],...
   r_struct.file,r_struct.obj,r_struct.protocol);

text2=' ';
text3=' ';
txt=' ';
it2=0;
strcompl='real data';
if strcmp(r_struct.obj,'mds') == 0
   binf='ascii';
   if strcmp(r_struct.nform,'ascii') == 0
      binf=r_struct.bform;
   end
else
   binf=r_struct.bform;
end

switch r_struct.obj
case 'gd'
   it2=1;
   if r_struct.complex == 1
      strcompl='complex data';
   end
   text3=sprintf(['  n = %d;  ini = %g;  dx = %g \n',...
      '   contains %s \n'],...
      r_struct.gd.n,r_struct.gd.ini,r_struct.gd.dx,strcompl);
case 'gd2'
   it2=1;
   if r_struct.complex == 1
      strcompl='complex data';
   end
   text3=sprintf(['  n = %d;  ini = %g;  dx = %g \n',...
      '  m = %d;  ini2 = %g;  dx2 = %g \n',...
      '   contains %s \n'],...
      r_struct.gd2.n,r_struct.gd2.ini,r_struct.gd2.dx, ...
      r_struct.gd2.m,r_struct.gd2.ini2,r_struct.gd2.dx2,strcompl);
case 'ds'
   it2=2;
case 'mds'
   it2=2;
   text3=sprintf([ '  The  binary format is %s \n' ...
      '   the file contains %d channels \n' ...
      '   the record length is %d \n\n' ...
      'kch          name       dt    length   nform \n'], ...
   binf,r_struct.mds.nch,r_struct.reclen);
   for i = 1:r_struct.mds.nch
      txt=sprintf(' %d %16s     %g   %d   %s \n',i,r_struct.mds.name{i},...
         r_struct.mds.dt(i),r_struct.mds.len(i),r_struct.mds.nform{i})
      text3=[text3 txt];
   end
   txt=sprintf('\n       The record header contains: \n');
   text3=[text3 txt];
   for i = 1:r_struct.mds.lheadd
      txt=sprintf(' %16s %70s \n',...
         r_struct.mds.headd.name{i},r_struct.mds.headd.capt{i});
      text3=[text3 txt];
   end
   for i = 1:r_struct.mds.lheadi
      txt=sprintf(' %16s %70s \n',...
         r_struct.mds.headi.name{i},r_struct.mds.headi.capt{i});
      text3=[text3 txt];
   end
case 'sfdb'
   it2=3;
case 'ev'
   it2=4;
end

switch it2
case 1
   text2=sprintf([ '  The %s name is %s \n' ...
      '   the format is %s and the binary format is %s \n'], ...
   r_struct.obj,r_struct.name,r_struct.nform,r_struct.bform);
case 2
   
end

text=[text1 text2 text3];