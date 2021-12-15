function fmnl_readfrtoc(fid,len,class,swp)


% FMNL_READFRTOC Reads Table Of Contents Data Structure. Used by FMNL_EXPLOREFR4
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
frTOC.uleaps=fread(fid,1,'int16');
frTOC.localtime=fread(fid,1,'int32');
frTOC.nframe=fread(fid,1,'uint32');
frTOC.gtimes=fread(fid,frTOC.nframe,'uint32');
frTOC.gtimen=fread(fid,frTOC.nframe,'uint32');
frTOC.framedurat=fread(fid,frTOC.nframe,'float64');
frTOC.runs=fread(fid,frTOC.nframe,'int32');
frTOC.framenumbers=fread(fid,frTOC.nframe,'uint32');
frTOC.positionframeH=fread(fid,frTOC.nframe,'uint64');
frTOC.nfirstadc=fread(fid,frTOC.nframe,'uint64');
frTOC.nfirstser=fread(fid,frTOC.nframe,'uint64');
frTOC.nfirsttable=fread(fid,frTOC.nframe,'uint64');
frTOC.nfirstmsg=fread(fid,frTOC.nframe,'uint64');
frTOC.nsh=fread(fid,1,'uint32');
frTOC.shid=fread(fid,frTOC.nsh,'uint16');

for i=1:frTOC.nsh
  frTOC.shname{i}=fmnl_read_string(fid);
end

frTOC.nstattype=fread(fid,1,'uint32');

if frTOC.nstattype ~= 0     %%
   for ii=1:frTOC.nstattype       
frTOC.namestat{i}=fmnl_read_string(fid);
frTOC.detector{i}=fmnl_read_string(fid);
fseek(fid,24,'cof');
   end
end

frTOC.nadc=fread(fid,1,'uint32');

if frTOC.nadc ~= 0
   for i=1:frTOC.nadc
   frTOC.nameadc{i}=fmnl_read_string(fid);
   end
   fseek(fid,(8*frTOC.nadc)+(8*frTOC.nframe*frTOC.nadc),'cof');
end

frTOC.nproc=fread(fid,1,'uint32');

if frTOC.nproc ~=0
   for i=1:frTOC.nproc
   frTOC.nameproc{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frTOC.nframe*frTOC.nproc,'cof');
end

frTOC.nsim=fread(fid,1,'uint32');

if frTOC.nsim ~=0
   for i=1:frTOC.nsim
   frTOC.namesim{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frTOC.nframe*frTOC.nsim,'cof');
end

frTOC.nser=fread(fid,1,'uint32');

if frTOC.nser ~=0
   for i=1:frTOC.nser
   frTOC.nameser{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frTOC.nframe*frTOC.nser,'cof');
end

frTOC.nsumm=fread(fid,1,'uint32');

if frTOC.nsumm ~=0
   for i=1:frTOC.nsumm
   frTOC.namesumm{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frTOC.nframe*frTOC.nsumm,'cof');
end

frTOC.ntrig=fread(fid,1,'uint32');

if frTOC.ntrig ~=0
   for i=1:frTOC.ntrig
   frTOC.nametrig{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*frTOC.nframe*frTOC.ntrig,'cof');
end

frTOC.nsimevent=fread(fid,1,'uint32');

if frTOC.nsimevent ~=0
   for i=1:frTOC.nsimevent
   frTOC.namesimevent{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*frTOC.nframe*frTOC.nsimevent,'cof');
end

if swp == 1
fprintf('\n');
frTOC
fprintf('\n\n');
end