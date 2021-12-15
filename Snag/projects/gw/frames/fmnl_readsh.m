function [dictname,classtype]=fmnl_readsh(fid,len,class,swp)

% FMNL_READSH   Reads the Frame Structure Header. Used by FMNL_EXPLOREFR4
%
%               fid -> file identifier 
%               len -> length of structure
%               class -> structure class
%               swp -> screen output switch ( 0 off , 1 on)
%
%               dictname -> Name of structure described by this dictionary structure
%               classtype -> Class number of structure being described
%
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


      k=fread(fid,1,'uint16');
      dictname=fmnl_read_string(fid);
      classtype=fread(fid,1,'uint16');
      comment=fmnl_read_string(fid);
      if swp == 1     
      fprintf('DICTIONARY STRUCTURE FOR %s \n\n',dictname);
      fprintf('Structure Class=%d \nClass number=%d \nOccurrence=%d \nComment=%s \nLength=%d \n\n',...
         class,classtype,k,comment,len);
      end
   