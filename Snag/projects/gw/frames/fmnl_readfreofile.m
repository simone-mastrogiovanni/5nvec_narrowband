function fmnl_readfreofile(fid,len,class,file,swp)

% FMNL_READFREOFILE Reads End Of File structure. Used by FMNL_EXPLOREFR4
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
nfr=fread(fid,1,'uint32');
nby=fread(fid,1,'uint32');
chkflg=fread(fid,1,'uint32');
chksum=fread(fid,1,'uint32');
sktoc=fread(fid,1,'uint32');

if swp == 1
fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',class,k,len);
fprintf('Number of frames in %s : %d \nNumber of bytes in this file = %d \n',file,nfr,nby);
fprintf('Flag for checksum = %d \nFile checksum value = %d \nBytes to back up to TOC = %d \n\n',...
   chkflg,chksum,sktoc);
end

