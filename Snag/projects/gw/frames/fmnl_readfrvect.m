function fmnl_readfrvect(fid,len,class,swp)

% FMNL_READFRVECT Reads Vector Data Structure. Used by FMNL_EXPLOREFR4
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


frvect.structureClass=class;
frvect.occurrence=fread(fid,1,'uint16');
frvect.length=len;
frvect.frvectorname=fmnl_read_string(fid);
frvect.compression=fread(fid,1,'uint16');
frvect.datatype=fread(fid,1,'uint16');
frvect.ndata=fread(fid,1,'uint32');
frvect.nbytes=fread(fid,1,'uint32');
frvect.data=fread(fid,frvect.nbytes,'ubit8');
frvect.ndim=fread(fid,1,'uint32');
frvect.nx=fread(fid,frvect.ndim,'uint32');
frvect.dx=fread(fid,frvect.ndim,'float64');
frvect.startx=fread(fid,frvect.ndim,'float64');
for i=1:frvect.ndim
   frvect.unitx{i}=fmnl_read_string(fid);
end
frvect.unity=fmnl_read_string(fid);

if swp == 1
fprintf('\n');
frvect
fprintf('\n\n');
end
