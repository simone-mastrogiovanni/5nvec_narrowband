function sfil=simfil_open(sfil)
%simfil_open   opens a "simple file"
%
%         sfil=simfil_open(sfil)
%
%   sfil    simple file structure

% Version 1.0 - September 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 2000  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sfil.fil=fopen(sfil.filnam,sfil.access);

if strcmp(sfil.access,'w') == 1
   if sfil.type == 1
	   fprintf(sfil.fil,'%15.6e %15.6e %d %d\n',...
   		sfil.init,sfil.samtim,sfil.nx,sfil.ny);
      fprintf(sfil.fil,'%s\n',sfil.caption);
   else
      fwrite(sfil.fil,sfil.init,'float64');
		fwrite(sfil.fil,sfil.samtim,'float64');
		fwrite(sfil.fil,sfil.nx,'int32');
		fwrite(sfil.fil,sfil.ny,'int32');
      fwrite(sfil.fil,sfil.caption,'uchar');
   end
else
   if sfil.type == 1
      a=fscanf(sfil.fil,'%e %e %d %d');
 		sfil.init=a(1);
      sfil.samtim=a(2);
      sfil.nx=a(3);
		sfil.ny=a(4);
 
 		sfil.caption=fscanf(sfil.fil,'%s',1);
 		sfil.caption
   else
      sfil.init=fread(sfil.fil,1,'float64')
		sfil.samtim=fread(sfil.fil,1,'float64')
		sfil.nx=fread(sfil.fil,1,'int32')
		sfil.ny=fread(sfil.fil,1,'int32')
      sfil.caption=string(fread(sfil.fil,80,'uchar')')
   end
end
   