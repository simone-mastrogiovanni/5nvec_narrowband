function fmnl_readfrdet(fid,len,class,swp)

% FMNL_READFRDET  Reads Detector Data Structure. Used by FMNL_EXPLOREFR4
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
namedet=fmnl_read_string(fid);
longd=fread(fid,1,'int16');
longm=fread(fid,1,'int16');
longs=fread(fid,1,'float32');
latd=fread(fid,1,'int16');
latm=fread(fid,1,'int16');
lats=fread(fid,1,'float32');
elev=fread(fid,1,'float32');
armx=fread(fid,1,'float32');
army=fread(fid,1,'float32');

if swp == 1
fprintf('\nName=%s \nStructure Class=%d \nOccurrence=%d \nLength=%d \n',...
   namedet,class,k,len);
fprintf('LongitudeD=%d \nLongitudeM=%d \nLongitudeS=%f \nLatitudeD=%d \n',...
   longd,longm,longs,latd);
fprintf('LatitudeM=%d \nLatitudeS=%f \nElevation=%f \nArmXazimuth=%f \n',...
   latm,lats,elev,armx);
fprintf('ArmYazimuth=%f \n\n',army);
end