function fmnl_readfrh(fid,len,class,swp)

% FMNL_READFRH Reads Frame Header Structure. Used by FMNL_EXPLOREFR4
%
%               fid -> file identifier 
%               len -> length of structure
%               class -> structure class
%               swp -> screen output switch ( 0 off , 1 on)
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


   k=fread(fid,1,'uint16');
   namefrh=fmnl_read_string(fid);
   run=fread(fid,1,'int32');
   frame=fread(fid,1,'uint32');
   dataq=fread(fid,1,'uint32');
   gts=fread(fid,1,'uint32');
   gtn=fread(fid,1,'uint32');
   uleaps=fread(fid,1,'uint16');
   localtime=fread(fid,1,'int32');      
   dt=fread(fid,1,'float64');
   
   if swp == 1
   fprintf('\nName=%s \nStructure Class=%d \nOccurrence=%d \nLen=%d \n',namefrh,class,k,len);
   fprintf('Run=%d \nFrame=%d \nDataQuality=%d \ngtimes=%d \ngtimen=%d \n',run,frame,dataq,gts,gtn);
   fprintf('Uleaps=%d \nLocaltime=%d \nFrame Length=%f \n\n',uleaps,localtime,dt);
   end