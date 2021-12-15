function fmnl_readfradc(fid,len,class,swp)

% FMNL_READFRADC   Reads ADC Data Structure. Used by FMNL_EXPLOREFR4
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
   name=fmnl_read_string(fid);
   comment=fmnl_read_string(fid);
   chgr=fread(fid,1,'uint32');
   chnr=fread(fid,1,'uint32');
   nbits=fread(fid,1,'uint32');
   bias=fread(fid,1,'float32');
   slope=fread(fid,1,'float32');
   units=fmnl_read_string(fid);
   samprt=fread(fid,1,'float64');
   timeoffs=fread(fid,1,'int32');
   timeoffn=fread(fid,1,'uint32');
   fshift=fread(fid,1,'float64');
   datav=fread(fid,1,'uint16');
   
   if swp == 1
   fprintf('\nName=%s \nStructure Class=%d \nOccurrence=%d \nLen=%d \n',name,class,k,len);
   fprintf('Comment=%s \nChannel Group=%d \n Channel Number=%d \nBits in AD output=%d \nBias=%f \n',...
      comment,chgr,chnr,nbits,bias);
   fprintf('Slope=%f \nUnits=%s \nSample Rate=%f \nTime OffsetS=%d \nTime OffsetN=%d \nfShift=%f\n',...
      slope,units,samprt,timeoffs,timeoffn,fshift);
   fprintf('Data Valid=%d \n\n',datav);
   end