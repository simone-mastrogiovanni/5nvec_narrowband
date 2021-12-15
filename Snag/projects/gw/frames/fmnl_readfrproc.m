function fmnl_readfrproc(fid,len,class,swp)

% FMNL_READFRPROC  Reads Post-Processed Data Structure. Used by FMNL_EXPLOREFR4
%
%                  fid -> file identifier 
%                  len -> length of structure
%                  class -> structure class
%                  swp -> screen output switch ( 0 off , 1 on)
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


k=fread(fid,1,'uint16');
namep=fmnl_read_string(fid);
commn=fmnl_read_string(fid);
sampr=fread(fid,1,'float64');
toffs=fread(fid,1,'uint32');
toffn=fread(fid,1,'uint32');
fshift=fread(fid,1,'float64');

if swp == 1
fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',...
   class,k,len);
fprintf('Name=%s \nComment=%s \nSample Rate=%f \ntimeOffsetS=%d \ntimeOffsetN=%d \n',...
   namep,commn,sampr,toffs,toffn);
fprintf('fShift=%f \n\n',fshift);
end