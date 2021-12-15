function mpstruct=fmnl_mp_seektoc(file)

% FMNL_MP_SEEKTOC 
%              
%              This function reads Table of Contents in 'file' and gets
%              parameters about multi selected channel
%              
%              mpstruct structure
%
%                      .fid       -> File identifier          
%                      .nframe    -> Number of framrs
%                      .nstattype -> Number of Static Data structures
%                      .posfrstat -> Position of FrStatData info in the Table of Contents
%                                    from beginning of file
%                      the same for FrAdc,FrProc,FrSim,FrSer,FrSummary,FrTrig,FrSimEvent
%                      .chk       -> Selected structure

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

mpstruct.fid=fid;

%

%Seek and read Table of Contents

[filename,permission,format] = fopen(fid);
fseek(fid,-4,'eof'); % Last 4 bytes of file are FrTOC position from bof
seekTOC=fread(fid,1,'uint32'); % Position of Table of Contents from bof
fseek(fid,-seekTOC+8,1); % Set pointer to the beginning of FrTOC + 8 bytes of Common Elements
uleaps=fread(fid,1,'int16');
loctime=fread(fid,1,'int32');
mpstruct.nframe=fread(fid,1,'uint32');
gtimes=fread(fid,mpstruct.nframe,'uint32');
gtimen=fread(fid,mpstruct.nframe,'uint32');
t0=gtimes(1)+gtimen(1)*1e-9;
framedurat=fread(fid,mpstruct.nframe,'float64');

%

skip1=48*mpstruct.nframe;
fseek(fid,skip1,'cof'); % Skip to number of FrSH structures

nsh=fread(fid,1,'uint32');
skip2=2*nsh;
fseek(fid,skip2,'cof');

for i=1:nsh
  shname=fmnl_read_string(fid);
end

mpstruct.nstattype=fread(fid,1,'uint32');

if mpstruct.nstattype ~= 0
mpstruct.posfrstat=ftell(fid);   
name=fmnl_read_string(fid);
name=fmnl_read_string(fid);
fseek(fid,24,'cof');
end

mpstruct.nadc=fread(fid,1,'uint32');

if mpstruct.nadc ~= 0
   mpstruct.posfradc=ftell(fid);
   for i=1:mpstruct.nadc
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,(8*mpstruct.nadc)+(8*mpstruct.nframe*mpstruct.nadc),'cof');
end

mpstruct.nproc=fread(fid,1,'uint32');

if mpstruct.nproc ~=0
   mpstruct.posfrproc=ftell(fid);
   for i=1:mpstruct.nproc
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*mpstruct.nframe*mpstruct.nproc,'cof');
end

mpstruct.nsim=fread(fid,1,'uint32');

if mpstruct.nsim ~=0
   mpstruct.posfrsim=ftell(fid);
   for i=1:mpstruct.nsim
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*mpstruct.nframe*mpstruct.nsim,'cof');
end

mpstruct.nser=fread(fid,1,'uint32');

if mpstruct.nser ~=0
   mpstruct.posfrser=ftell(fid);
   for i=1:mpstruct.nser
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*mpstruct.nframe*mpstruct.nser,'cof');
end

mpstruct.nsumm=fread(fid,1,'uint32');

if mpstruct.nsumm ~=0
   mpstruct.posfrsumm=ftell(fid);
   for i=1:mpstruct.nsumm
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*mpstruct.nframe*mpstruct.nsumm,'cof');
end

mpstruct.ntrig=fread(fid,1,'uint32');

if mpstruct.ntrig ~=0
   mpstruct.posfrtrig=ftell(fid);
   for i=1:mpstruct.ntrig
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*mpstruct.nframe*mpstruct.ntrig,'cof');
end

mpstruct.nsimevent=fread(fid,1,'uint32');

if mpstruct.nsimevent ~=0
   mpstruct.posfrsimevent=ftell(fid);
   for i=1:mpstruct.nsimevent
   name{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*mpstruct.nframe*mpstruct.nsimevent,'cof');
end

% Choice a Structure of Data

indstruct=[mpstruct.nstattype mpstruct.nadc mpstruct.nproc mpstruct.nsim...
      mpstruct.nser mpstruct.nsumm mpstruct.ntrig mpstruct.nsimevent];
structname={'FrStatData' 'FrAdcData' 'FrProcData' 'FrSimData' 'FrSerData' 'Frsummary'...
      'FrTrigData' 'FrSimEvent'};
nozeroinf=find(indstruct);

[sel,ok]=listdlg('PromptString',{'Select a Structure from List:' ''},...
   'Name','Data Structure Explorer',... 
   'selectionmode','single',...
   'ListSize',[230,200],...
   'Liststring',structname(nozeroinf));

mpstruct.chk=structname{nozeroinf(sel)};