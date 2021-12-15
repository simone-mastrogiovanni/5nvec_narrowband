function fmnl_readfrtrig(fid,len,class,swp)

% FMNL_READFRTRIG  Reads Trigger Data Structure. Used by FMNL_EXPLOREFR4
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
namet=fmnl_read_string(fid);
commn=fmnl_read_string(fid);
inputs=fmnl_read_string(fid);
gts=fread(fid,1,'uint32');
gtn=fread(fid,1,'uint32');
timeb=fread(fid,1,'float32');
timea=fread(fid,1,'float32');
trigst=fread(fid,1,'uint32');
ampl=fread(fid,1,'float32');
prob=fread(fid,1,'float32');
statist=fmnl_read_string(fid);

if swp == 1
fprintf('\nStructure Class=%d \nOccurrence=%d \nLength=%d \n',class,k,len);
fprintf('Name=%s \nComment=%s \nInput Channels=%s \n',namet,commn,inputs);
fprintf('GPS time maximum trigger=%d (sec) \nGPS time residual=%d (nsec) \n',gts,gtn);
fprintf('Signal duration before=%f \nSignal duration after=%f \n',timeb,timea);
fprintf('TriggerStatus=%d \nAmplitude=%f \n',trigst,ampl);
fprintf('Probability=%f \nStatistics=%s \n\n',prob,statist);
end


