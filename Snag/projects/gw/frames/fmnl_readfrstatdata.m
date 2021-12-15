function fmnl_readfrstatdata(fid,len,class,swp)

% FMNL_READFRSTATDATA    Reads Static Data Structure. Used by FMNL_EXPLOREFR4
%
%                        fid -> file identifier 
%                        len -> length of structure
%                        class -> structure class
%                        swp -> screen output switch ( 0 off , 1 on)
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


k=fread(fid,1,'uint16');
namest=fmnl_read_string(fid);
commn=fmnl_read_string(fid);
repr=fmnl_read_string(fid);
timestr=fread(fid,1,'uint32');
timeend=fread(fid,1,'uint32');
version=fread(fid,1,'uint32');

if swp == 1
fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',...
   class,k,len);
fprintf('Name=%s \nComment=%s \nRepresentation=%s \n',...
   namest,commn,repr);
fprintf('Time Start=%d \nTime End=%d \nVersion=%d \n',...
   timestr,timeend,version);
end