function write_snf_gd(g,file,form)
%write_snf_gd(g,file)  write a gd SNF file
%
%    g      the gd or gd2
%    file   the output file
%    form   output format 
%           ('ascii' 'int8' 'int16' 'log8' 'log16' 'float' 'double')

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

name=inputname(1);
w_struct.file=file;
w_struct.nform=form;
iscompl=testcomplex(g);
w_struct.complex=iscompl;
isagd=isa(g,'gd');
xreal=0;

switch isagd
case 1
   w_struct.obj='gd';
   w_struct.gd.name=name;
   w_struct.gd.n=n_gd(g);
   w_struct.gd.ini=ini_gd(g);
   w_struct.gd.dx=dx_gd(g);
   w_struct.gd.capt=capt_gd(g);
   w_struct.gd.type=type_gd(g);
   w_struct.capt=capt_gd(g);
   y=y_gd(g);
   if w_struct.gd.type == 2
      x=x_gd(g);
      xreal=1;
   end
case 0
   w_struct.obj='gd2';
   w_struct.gd2.name=name;
   w_struct.gd2.n=n_gd2(g);
   w_struct.gd2.ini=ini_gd2(g);
   w_struct.gd2.dx=dx_gd2(g);
   w_struct.gd2.capt=capt_gd2(g);
   w_struct.gd2.type=type_gd2(g);
   w_struct.gd2.m=m_gd2(g);
   w_struct.gd2.ini2=ini2_gd2(g);
   w_struct.gd2.dx2=dx2_gd2(g);
   w_struct.capt=capt_gd2(g);
   y=y_gd2(g);
   if w_struct.gd2.type == 2
      x=x_gd2(g);
      xreal=1;
   end
end

fid=write_snf_header(w_struct);

if xreal == 1
   if strcmp(wform,'ascii') == 1
      fprintf(fid,'%g ',x);
   else
      fwrite(fid,x,'float64');
   end
end

wform=form;
switch form
case 'log8'
   wform='uint8';
case 'log16'
   wform='uint16';
case 'float'
   wform='float32';
case 'double'
   wform='float64';
end

if strcmp(wform,'ascii') == 1
   fprintf(fid,'%g ',y);
else
   fwrite(fid,y,wform);
end
   
fclose(fid);
