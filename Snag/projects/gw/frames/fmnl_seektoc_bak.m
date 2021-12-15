function [chs,dt,dlen,frame4par]=fmnl_seektoc(file)

% FMNL_SEEKTOC 
%              This function reads Table of Contents in 'file' and gets
%              parameters about the selected channel
%              
%              chs  -> Name of selected channel
%              dt   -> Sampling time
%              dlen -> Length of data vector
%              
%                   frame4par structure
%              frame4par.machtype -> Machine type (see 'fopen' for details)
%                       .uleaps   -> Leap seconds between GPS/TAI and UTC
%                       .nframe	 -> Numer of frames in 'file'
%                       .loctime  -> Local seasonal time -UTC in seconds
%                       .t0       -> Frame start time
%                       .dt       -> Sampling time
%                       .framedurat -> Frame durations in sec
%                       .distch(nframe) -> Positions of selected channel in bytes from
%                                          beginning of file
%                       .compress -> Compression type
%                       .type -> Data type
%                       .ndata -> Length of data vector (same as dlen)

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


% Check for Machine format

ff={'n' 's' 'l' 'b' 'a' 'g' 'd' 'c'};
for i = 1:8
   [fid message]=fopen(file,'r',ff{i});
   if fid < 0
      disp([file ' <->' message]);
   end
   
   fseek(fid,26,'bof');
   
	pising=fread(fid,1,'float32');
	pidobl=fread(fid,1,'float64');
   
   if pising ~= 0
      if abs((pidobl-3.14159265358979)/3.14159265358979) < 0.001
         break
      end
   end
end

frame4par.machtype=ff{i};

%

%Seek and read Table of Contents

[filename,permission,format] = fopen(fid);
fseek(fid,-4,'eof'); % Last 4 bytes of file are FrTOC position from bof
seekTOC=fread(fid,1,'uint32'); % Position of Table of Contents from bof
fseek(fid,-seekTOC+8,1); % Set pointer to the beginning of FrTOC + 8 bytes of Common Elements
frame4par.uleaps=fread(fid,1,'int16');
frame4par.loctime=fread(fid,1,'int32');
frame4par.nframe=fread(fid,1,'uint32');
gtimes=fread(fid,frame4par.nframe,'uint32');
gtimen=fread(fid,frame4par.nframe,'uint32');
frame4par.t0=gtimes(1)+gtimen(1)*1e-9;
frame4par.framedurat=fread(fid,frame4par.nframe,'float64');

%

skip1=48*frame4par.nframe;
fseek(fid,skip1,'cof'); % Skip to number of FrSH structures

nsh=fread(fid,1,'uint32');
skip2=2*nsh;
fseek(fid,skip2,'cof');

for i=1:nsh
  shname=fmnl_read_string(fid);
end

nstattype=fread(fid,1,'uint32');

if nstattype ~= 0     %%
   for ii=1:nstattype       
frame4par.posfrstat(ii)=ftell(fid);   
name=fmnl_read_string(fid);
name=fmnl_read_string(fid);
fseek(fid,24,'cof');
   end
end

nadc=fread(fid,1,'uint32');

if nadc ~= 0
   frame4par.posfradc=ftell(fid);
   for i=1:nadc
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,(8*nadc)+(8*frame4par.nframe*nadc),'cof');
end

nproc=fread(fid,1,'uint32');

if nproc ~=0
   frame4par.posfrproc=ftell(fid);
   for i=1:nproc
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frame4par.nframe*nproc,'cof');
end

nsim=fread(fid,1,'uint32');

if nsim ~=0
   frame4par.posfrsim=ftell(fid);
   for i=1:nsim
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frame4par.nframe*nsim,'cof');
end

nser=fread(fid,1,'uint32');

if nser ~=0
   frame4par.posfrser=ftell(fid);
   for i=1:nser
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frame4par.nframe*nser,'cof');
end

nsumm=fread(fid,1,'uint32');

if nsumm ~=0
   frame4par.posfrsumm=ftell(fid);
   for i=1:nsumm
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*frame4par.nframe*nsumm,'cof');
end

ntrig=fread(fid,1,'uint32');

if ntrig ~=0
   frame4par.posfrtrig=ftell(fid);
   for i=1:ntrig
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*frame4par.nframe*ntrig,'cof');
end

nsimevent=fread(fid,1,'uint32');

if nsimevent ~=0
   frame4par.posfrsimevent=ftell(fid);
   for i=1:nsimevent
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*frame4par.nframe*nsimevent,'cof');
end

% Choice a Structure of Data

indstruct=[nstattype nadc nproc nsim...
      nser nsumm ntrig nsimevent];
structname={'FrStatData' 'FrAdcData' 'FrProcData' 'FrSimData' 'FrSerData' 'Frsummary'...
      'FrTrigData' 'FrSimEvent'};
nozeroinf=find(indstruct);

[sel,ok]=listdlg('PromptString',{'Select a Structure from List:' ''},...
   'Name','Data Structure Explorer',... 
   'selectionmode','single',...
   'ListSize',[230,200],...
   'Liststring',structname(nozeroinf));

chk=structname{nozeroinf(sel)};

switch chk
   
case 'FrStatData'
   
case 'FrAdcData'
   
   fseek(fid,frame4par.posfradc,'bof');
   for i=1:nadc
   adcname{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*nadc,'cof');
   [sel,ok]=listdlg('PromptString',{'Select ADCData from List:' ''},...
   'Name','ADCData Explorer',... 
   'selectionmode','single',...
   'ListSize',[260,400],...
   'Liststring',adcname);

chs=adcname{sel};

if ok == 0
   return
end

   blk=8*frame4par.nframe*(sel-1);
   fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
   frame4par.distch=fread(fid,frame4par.nframe,'uint64'); % Read positions ...
                                                        ... of channel through all the frames
      
   fseek(fid,frame4par.distch(1),'bof'); % Set pointer to first channel
   lenfradc=fread(fid,1,'uint32'); % Read AdcData Header length
   fseek(fid,lenfradc-42,'cof'); % Go to samprate variable
   samprate=fread(fid,1,'float64');
   dt=(1/samprate);
   frame4par.dt=dt;
   fseek(fid,38,'cof'); % Go to FrVect(AdcData) + 8 bytes of Common Elements
   cname=fmnl_read_string(fid);
   frame4par.compress=fread(fid,1,'uint16'); %Read compression type
   
   %if frame4par.compress == 0 | frame4par.compress == 256
      
   typ=fread(fid,1,'uint16');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64'...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
   nbtypedata=[1 2 8 4 4 8 4 8 2 2 4 8];
   frame4par.typ=typ+1;
   frame4par.nbtype=nbtypedata(typ+1);   
   frame4par.type=typedata{typ+1};
   dlen=fread(fid,1,'uint32'); % ndata
   frame4par.ndata=dlen;
   
   
   %else
   %   fprintf('Compressed Data \nCompression type: %d \n',frame4par.compress);
   %   keyboard
   %end
     
case 'FrProcData'
case 'FrSimData'
case 'FrSerData'
   
   fseek(fid,frame4par.posfrser,'bof');
   
   for i=1:nser
   sername{i}=fmnl_read_string(fid);
   end
   
   [sel,ok]=listdlg('PromptString',{'Select Serial Data from List:' ''},...
   'Name','SerData Explorer',... 
   'selectionmode','single',...
   'ListSize',[260,400],...
   'Liststring',sername);

    chs=sername{sel};
    
    if ok == 0
    return
    end
 
   blk=8*frame4par.nframe*(sel-1);
   fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
   frame4par.distch=fread(fid,frame4par.nframe,'uint64'); % Read positions ...
                                                        ... of channel through all the frames
   fseek(fid,frame4par.distch(1),'bof'); % Set pointer to first channel                                                        
   lenfrser=fread(fid,1,'uint32');   
   fseek(fid,4,'cof');
   name=fmnl_read_string(fid);
   fseek(fid,8,'cof'); % Go to samprate variable
   samprate=fread(fid,1,'float32');
   dt=(1/samprate);
   frame4par.dt=dt;
   fseek(fid,frame4par.distch(1)+lenfrser+8,'bof'); % Go to FrVect(AdcData) + 8 bytes of Common Elements
   cname=fmnl_read_string(fid);
   frame4par.compress=fread(fid,1,'uint16'); %Read compression type
   
   if frame4par.compress == 0 | frame4par.compress == 256
      
   typ=fread(fid,1,'uint16');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64'...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
   frame4par.type=typedata{typ+1};
   dlen=fread(fid,1,'uint32'); % ndata
   frame4par.ndata=dlen;
       
   else
      fprintf('Compressed Data \nCompression type: %d \n',frame4par.compress);
      keyboard
   end


case 'Frsummary'
case 'FrTrigData'
case 'FrSimEvent'
end
