function fmnl_readfrtable(fid,len,class)

% FMNL_READFRTABLE   Reads Table Structure. Used by FMNL_EXPLOREFR4
%
%                    fid -> file identifier 
%                    len -> length of structure
%                    class -> structure class
%                    swp -> screen output switch ( 0 off , 1 on)
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


k=fread(fid,1,'uint16');
namet=fmnl_read_string(fid);
commn=fmnl_read_string(fid);
ncol=fread(fid,1,'uint16');
nrow=fread(fid,1,'uint32');

fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',class,k,len);
fprintf('Name = %s \nComment = %s \Number of colums in table = %d \nNumber of rows in table = %d \n\n',...
   namet,commn,ncol,nrow);

