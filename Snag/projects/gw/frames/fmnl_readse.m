function fmnl_readse(fid,len,class,swp)

% FMNL_READSE   Reads the second element of a Dictionary-type Structure. Used by FMNL_EXPLOREFR4
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
         name=fmnl_read_string(fid);
         type=fmnl_read_string(fid);
         comment=fmnl_read_string(fid);
         
         if swp == 1
         fprintf('Second Element of a dictionary-type structure \n\n');
         fprintf('Structure Class=%d \nOccurrence=%d \nName=%s \nType=%s \nComment=%s \nLength=%d \n\n',...
         class,k,name,type,comment,len);
         end