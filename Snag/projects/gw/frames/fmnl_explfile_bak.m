function fmnl_explfile(file)

%    FMNL_EXPLFILE(file) Browser for Frame file
%
%
%

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


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

%

%Seek and read Table of Contents

[filename,permission,format] = fopen(fid);
fseek(fid,-4,'eof'); % Last 4 bytes of file are FrTOC position from bof
seekTOC=fread(fid,1,'uint32'); % Position of Table of Contents from bof
fseek(fid,-seekTOC+8,1); % Set pointer to the beginning of FrTOC + 8 bytes of Common Elements
uleaps=fread(fid,1,'int16');
loctime=fread(fid,1,'int32');
nframe=fread(fid,1,'uint32');
gtimes=fread(fid,nframe,'uint32');
gtimen=fread(fid,nframe,'uint32');
t0=gtimes(1)+gtimen(1)*1e-9;
framedurat=fread(fid,nframe,'float64');

fprintf('\n******************\n\n');
fprintf('File Overview :\n\n\n');
fprintf('Uleaps: %d\n\n',uleaps);
fprintf('Starting Time : %d (sec) \n\n',t0);
fprintf('Total number of frame in %s : %d\n\n',file,nframe);
fprintf('Frames Total duration : %d (sec) \n\n',sum(framedurat));

%

skip1=48*nframe;
fseek(fid,skip1,'cof'); % Skip to number of FrSH structures

nsh=fread(fid,1,'uint32');
skip2=2*nsh;
fseek(fid,skip2,'cof');

for i=1:nsh
  shname=fmnl_read_string(fid);
end


nstattype=fread(fid,1,'uint32');

if nstattype ~= 0
posstat=ftell(fid);
statname=fmnl_read_string(fid);
detectname=fmnl_read_string(fid);
fseek(fid,24,'cof');
end

nadc=fread(fid,1,'uint32');

if nadc ~= 0
   posfradc=ftell(fid)
   for i=1:nadc
   adcname{i}=fmnl_read_string(fid);
   end
   fseek(fid,(8*nadc)+(8*nframe*nadc),'cof');
end

nproc=fread(fid,1,'uint32');

if nproc ~=0
   posproc=ftell(fid);
   for i=1:nproc
   procname{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*nframe*nproc,'cof');
end

nsim=fread(fid,1,'uint32');

if nsim ~=0
   possim=ftell(fid);
   for i=1:nsim
   simname{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*nframe*nsim,'cof');
end

nser=fread(fid,1,'uint32');

if nser ~=0
   posfrser=ftell(fid);
   for i=1:nser
   pname=fmnl_read_string(fid);
   end
   fseek(fid,8*nframe*nser,'cof');
end

nsumm=fread(fid,1,'uint32');

if nsumm ~=0
   posfrsumm=ftell(fid);
   for i=1:nsumm
   name=fmnl_read_string(fid);
   end
   fseek(fid,8*nframe*nsumm,'cof');
end

ntrig=fread(fid,1,'uint32');

if ntrig ~=0
   postrig=ftell(fid);
   for i=1:ntrig
   trigname{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*nframe*ntrig,'cof');
end

nsimevent=fread(fid,1,'uint32');

if nsimevent ~=0
   possimevent=ftell(fid);
   for i=1:nsimevent
   simeventname{i}=fmnl_read_string(fid);
   end
   fseek(fid,16*nframe*nsimevent,'cof');
end

% Choice a Structure of Data

indstruct=[nstattype nadc nproc nsim...
      nser nsumm ntrig nsimevent];
structname={'FrStatData' 'FrAdcData' 'FrProcData' 'FrSimData' 'FrSerData' 'Frsummary'...
      'FrTrigData' 'FrSimEvent'};
nozeroinf=find(indstruct);

for jj=1:length(nozeroinf)
   nstrname{jj}=sprintf('%s     %d structures',structname{nozeroinf(jj)},indstruct(nozeroinf(jj)));
end

[sel,ok]=listdlg('PromptString',{'Select a Structure for more Info:' ''},...
   'Name','Data Structure Explorer',... 
   'selectionmode','single',...
   'ListSize',[230,200],...
   'Liststring',nstrname);

chk=structname{nozeroinf(sel)};

switch chk
   
case 'FrStatData'
   
   fseek(fid,frame4par.posfrstat,'bof');
   for i=1:nstat
   statname{i}=fmnl_read_string(fid);
   end
   fseek(fid,8*nstat,'cof');
   [sel,ok]=listdlg('PromptString',{'Select ADCData from List:' ''},...
   'Name','ADCData Explorer',... 
   'selectionmode','single',...
   'ListSize',[260,400],...
   'Liststring',statname);

chs=statname{sel};
   
   
   
   
case 'FrAdcData'
   
   fseek(fid,posfradc,'bof');
   for i=1:nadc
   name=fmnl_read_string(fid);
   end
   fseek(fid,8*nadc,'cof');
   posini=ftell(fid)
   
   for i=1:nadc
      
   fseek(fid,posini,'bof');   
   blk=8*nframe*(i-1)+0; % !!!!
   fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
   distch(i)=fread(fid,1,'uint64'); % Read positions ...
                                                        ... of channel through all the frames
      
   fseek(fid,distch(i),'bof'); % Set pointer to first channel
   lenfradc=fread(fid,1,'uint32'); % Read AdcData Header length
   fseek(fid,lenfradc-42,'cof'); % Go to samprate variable
   samprate(i)=fread(fid,1,'float64');
   dt(i)=(1/samprate(i));
   fseek(fid,38,'cof'); % Go to FrVect(AdcData) + 8 bytes of Common Elements
   oadcname{i}=fmnl_read_string(fid);
   compress(i)=fread(fid,1,'uint16'); %Read compression type
   
   typ=fread(fid,1,'uint16');
   % pos=ftell(fid);
   % fprintf('lenfradc=%d   nadci=%d   distchi=%d   typ=%d   compress=%d \n',lenfradc,i,distch(i),typ,compress(i)); %
   
   if typ >= 0 & typ <= 11
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64' ...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
   ctype{i}=char(typedata{typ+1});
   ndata(i)=fread(fid,1,'uint32'); % ndata
   else
      pos=ftell(fid);
      % fprintf('name=%s  i=%d   typ=%d   distch=%d  pos=%d \n',char(adcname{i}),i,typ,distch(i),pos);
      dt(i)=0;
      ctype{i}='WARNING! ERROR IN DATA TYPE';
      ndata(i)=0;
   end
   
   end
   
   menutext='ADC Data Browser';
   text1{1}='NOT COMPRESSED DATA'; 
   text2{1}='COMPRESSED DATA';
   text1{2}=sprintf('Num Ch --> Ch name --> Ndata --> SampTime --> Comp --> Type');
   text2{2}=text1{2};
   text1{3}='Null';
   text2{3}=text1{3};
   k=1;
   kk=1;
   for i=1:nadc
   if compress(i) == 0 | compress(i) == 256   
   text1{k+2}=sprintf('%d --> %s --> %d --> %f --> %d --> %s',i,char(adcname{i}),ndata(i),dt(i),compress(i),...
         char(ctype{i}));
   k=k+1; 
   else
   text2{kk+2}=sprintf('%d --> %s --> %d --> %f --> %d --> %s',i,char(adcname{i}),ndata(i),dt(i),compress(i),...
         char(ctype{i}));   
   kk=kk+1;   
   end
   end

   fmnl_windexp(menutext,text1,text2);
     
case 'FrProcData'
case 'FrSimData'
case 'FrSerData'
   
   fseek(fid,posfrser,'bof');
   
   for i=1:nser
    name=fmnl_read_string(fid);
   end
   
   posini=ftell(fid);
   
   for i=1:nser
   fseek(fid,posini,'bof');
   blk=8*nframe*(i-1);
   fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
   distch(i)=fread(fid,1,'uint64') % Read positions of channels through the file
   fseek(fid,distch(i),'bof'); % Set pointer to "i" channel                                                        
   lenfrser=fread(fid,1,'uint32');
   fseek(fid,4,'cof');
   sername{i}=fmnl_read_string(fid);
   fseek(fid,8,'cof'); % Go to samprate variable
   samprate(i)=fread(fid,1,'float32');
   dt(i)=(1/samprate(i));
   fseek(fid,distch(i)+lenfrser-12,'bof'); % Go to FrVect(Data) + 8 bytes of Common Elements
   cl=fread(fid,1,'uint16');
   in=fread(fid,1,'uint16');
   if cl ~= 0 & in ~= 0
   fseek(fid,distch(i)+lenfrser+8,'bof');
   name=fmnl_read_string(fid)
   compress(i)=fread(fid,1,'uint16'); % Read compression type
   typ=fread(fid,1,'uint16');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64' ...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
   ctype{i}=typedata{typ+1};
   ndata(i)=fread(fid,1,'uint32'); % ndata
   presvect{i}='yes';
   else
   presvect{i}='no';
end
end

menutext='SerData Explorer';
text{1}=sprintf('Name --> Data Vector');
for i=1:nser
   text{i+1}=sprintf('%s --> %s',char(sername{i}),char(presvect{i}));
   end
   
   fmnl_windexp(menutext,text);
   
case 'Frsummary'
   
   fseek(fid,posfrsumm,'bof');
   
   for i=1:nsumm
   name=fmnl_read_string(fid);
   end
   
   posini=ftell(fid);
     
   for i=1:nsumm
   fseek(fid,posini,'bof');
   blk=8*nframe*(i-1);
   fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
   distch(i)=fread(fid,1,'uint64') % Read positions of channels through the file
   fseek(fid,distch(i),'bof') % Set pointer to "i" channel
   lenfrsumm=fread(fid,1,'uint32');
   fseek(fid,4,'cof');
   summname{i}=fmnl_read_string(fid);
   comment=fmnl_read_string(fid);
   test{i}=fmnl_read_string(fid);
   cl=fread(fid,1,'uint16');
   in=fread(fid,1,'uint16');
   if cl ~= 0 & in ~= 0
   fseek(fid,distch(i)+lenfrsumm+8,'bof');
   name=fmnl_read_string(fid)
   compress(i)=fread(fid,1,'uint16'); %Read compression type
   typ=fread(fid,1,'uint16');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64' ...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
   ctype{i}=typedata{typ+1};
   ndata(i)=fread(fid,1,'uint32'); % ndata
   presvect{i}='yes';
   else
   presvect{i}='no';
   end

   
   
   end
   menutext='Summary Data Explorer'
   text{1}=sprintf('Name --> Test -->Data Vector');
   for i=1:nsumm
   text{i+1}=sprintf('%s --> %s --> %s',char(summname{i}),char(test{i}),char(presvect{i}));
   end
   
   fmnl_windexp(menutext,text);
  
   
                                          
case 'FrTrigData'
case 'FrSimEvent'
end

fclose(fid);
