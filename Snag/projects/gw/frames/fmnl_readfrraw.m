function fmnl_readfrraw(fid,len,class,swp)

% FMNL_READFRRAW  Reads Raw Data Structure. Used by FMNL_EXPLOREFR4
%
%                 fid -> file identifier 
%                 len -> length of structure
%                 class -> structure class
%                 swp -> screen output switch ( 0 off , 1 on)
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


k=fread(fid,1,'uint16');
namer=fmnl_read_string(fid);

if swp == 1
fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',...
   class,k,len);
fprintf('Name=%s \n\n',namer);
end