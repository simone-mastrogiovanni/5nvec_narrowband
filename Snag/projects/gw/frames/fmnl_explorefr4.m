function fmnl_explorefr4(file)

%FUNCTION FMNL_EXPLORERFR4      Browse Frame Format 4 files
%                 
%                          
%
% Version 1.0 - March 1999
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

posini=ftell(fid);

%

[filename,permission,format] = fopen(fid);

fseek(fid,-24,'eof');
classfreof=fread(fid,1,'uint16'); % Reads the structure class for FrEndOfFile

fseek(fid,40,'bof');

[sel,ok]=listdlg('PromptString',{'Select an option:' ''},...
  				 'Name','Frame file Explorer',...
                'SelectionMode','single',...
                'ListSize',[250,300],...   
                'ListString',{'Display all structures'...
                   'Display structures 1'...
                   'Display structures 1 and 2'...
                   'Display structures of type x'...
                   'Only the first x structures'...
                   'Structure sequence raw'...
                   'Structure sequence analytical'...
                   'Show FrVect'...
                   'Quick Mode'...
                   'Only resume'});
             
             class=1000;
             
             
 listsh={'FrameH' 'FrAdcData' 'FrDetector' 'FrEndOfFrame' ...
  'FrMsg' 'FrHistory' 'FrRawData' 'FrProcData' 'FrSimData' ...
  'FrSerData' 'FrStatData' 'FrVect' 'FrTrigData' 'FrSummary' ...
  'FrTable' 'FrTOC' 'FrEndOfFile'};
 
 iii=1000000000; % Just a control variable set to a very large number
 ii=0;
 swp =1; % swp is a switch controlling the screen output of some routines (1 = on ; 0 = off)
 numsr=zeros(1,20);
 nsh=zeros(1,16);

if sel == 9               % Quick Mode
   fmnl_explfile(file);
end

if sel == 10              % Only Resume
   fprintf('\nReading file %s ...please wait...\n\n',file);
   swp=0;
   while class ~= classfreof  % It looks for structures until it reaches the FrEndofFile
      posinii=ftell(fid); % Beginning of structure
      len=fread(fid,1,'uint32'); % Length of structure
      posinif=posinii+len;
      class=fread(fid,1,'uint16'); % Reads the class structure
      
      [nsh,numsr]=fmnl_switstr(fid,len,class,swp,listsh,nsh,numsr,file); % This routine reads structures parameters
      
      fseek(fid,posinif,'bof');
      
   end
   fprintf('Open file -- > %s \n',file);
      fprintf('Structure name \t Structure class \t Number of Structures\n');
      fprintf('%14s \t %15d \t %d\n','SH',1,numsr(1));
      fprintf('%14s \t %15d \t %d\n','SE',2,numsr(2));
      for j=1:17
         fprintf('%14s \t %15d \t %d \n',char(listsh{j}),nsh(j),numsr(j+2));
      end
 end
  
if sel == 1 | sel == 5     % Display all structures (sel = 1) or only x structures (sel = 5)
   
   if sel == 5
   answ=inputdlg({'Init number' 'Final number'},...
   'Enter number of structures to display',2,...
 	{'1' '1000000'});
   nmin=eval(answ{1});
   nmax=eval(answ{2});
   iii=nmax;
   end
   
   
      while class ~= classfreof & ii < iii
         
      ii = ii+1;
      if sel == 5 & ii < nmin % Set swp = 0 until it reaches the selected structures
         swp =0;
      else
         swp=1;
      end
        
      
      posinii=ftell(fid);
      len=fread(fid,1,'uint32');
      posinif=posinii+len;
      class=fread(fid,1,'uint16');
      
      [nsh,numsr]=fmnl_switstr(fid,len,class,swp,listsh,nsh,numsr,file);
      
      if sel == 1
         reply=input('Press E to exit, any other key to continue\n\n','s');
         if strcmp(reply,'E') | strcmp(reply,'e')
         return
         end
      elseif sel == 5 & ii >= nmin
         reply=input('Press E to exit, any other key to continue\n\n','s');
         if strcmp(reply,'E') | strcmp(reply,'e')
         return
      end
   end
   
               
      fseek(fid,posinif,'bof');
      
      end % While
       
      if sel == 1
      fprintf('Open file -- > %s \n',file);
      fprintf('Structure name \t Structure class \t Number of Structures\n');
      fprintf('%14s \t %15d \t %d\n','SH',1,numsr(1));
      fprintf('%14s \t %15d \t %d\n','SE',2,numsr(2));
      for j=1:17
         fprintf('%14s \t %15d \t %d \n',char(listsh{j}),nsh(j),numsr(j+2));
      end
      end
   
end
   
if sel == 2  % Display structures of class 1
   
while class ~= classfreof 
   
   posinif=ftell(fid);
   len=fread(fid,1,'uint32');
   class=fread(fid,1,'uint16');
   
   
   if class == 1
      fmnl_readsh(fid,len,class,swp);
      reply=input('Press E to exit, any other key to continue\n\n','s');
      
      if strcmp(reply,'E') | strcmp(reply,'e')
      return
      end
   
   end

fseek(fid,posinif+len,'bof');

end
end

if sel == 3  % Display structures of classes 1 and 2
   
   while class ~= classfreof
   posinif=ftell(fid);
   len=fread(fid,1,'uint32');
   class=fread(fid,1,'uint16');
   
   if class == 1
      fmnl_readsh(fid,len,class,swp);
      reply=input('Press E to exit, any other key to continue\n\n','s');
      
      if strcmp(reply,'E') | strcmp(reply,'e')
      return
      end
   elseif class == 2
         fmnl_readse(fid,len,class,swp);
         reply=input('Press E to exit, any other key to continue\n\n','s');
      
      if strcmp(reply,'E') | strcmp(reply,'e')
      return
      end
   end 
   
   fseek(fid,posinif+len,'bof');
   end
end

if sel == 4  % Display structures of a class selected by user
   answ=inputdlg('Enter type number',...
      'Display structures of type...');
   ntyp=eval(answ{1});
   iststring={'fmnl_readse(fid,len,class,swp);' 'fmnl_readfrh(fid,len,class,swp);'...
         'fmnl_readfradc(fid,len,class,swp);' 'fmnl_readfrdet(fid,len,class,swp);' 'fmnl_readfreof(fid,len,class,swp);'...
         'fmnl_readfrmsg(fid,len,class,swp);' 'fmnl_readfrhist(fid,len,class,swp);' 'fmnl_readfrraw(fid,len,class,swp);'...
         'fmnl_readfrproc(fid,len,class,swp);' 'fmnl_readfrsimd(fid,len,class,swp);' 'fmnl_readfrserdata(fid,len,class,swp);'...
         'fmnl_readfrstatdata(fid,len,class,swp);' 'fmnl_readfrvect(fid,len,class,swp);' 'fmnl_readfrtrig(fid,len,class,swp);'...
         'fmnl_readfrsumm(fid,len,class,swp);' 'fmnl_readfrtable(fid,len,class,swp);' 'fmnl_readfrtoc(fid,len,class,swp);'...
         'fmnl_readfreofile(fid,len,class,file,swp);'};
         
   nshh=zeros(1,20);
   nshh(1)=2;
      
   while class ~= classfreof
   posinif=ftell(fid);
   len=fread(fid,1,'uint32');
   class=fread(fid,1,'uint16');
   if class == 1
   k=fread(fid,1,'uint16');
   namefr=fmnl_read_string(fid);
   classtype=fread(fid,1,'uint16');
   comment=fmnl_read_string(fid);
   x=strmatch(cellstr(namefr),listsh,'exact'); % 
   nshh(x+1)=classtype;
   
   if ntyp == 1
      fprintf('DICTIONARY STRUCTURE FOR %s \n\n',namefr);
      fprintf('Structure Class=%d \nClass number=%d \nOccurrence=%d \nComment=%s \nLength=%d \n\n',...
         class,classtype,k,comment,len);
      
      reply=input('Press E to exit, any other key to continue\n\n','s');
      if strcmp(reply,'E') | strcmp(reply,'e')
      return
      end
   end
   
   elseif class == ntyp & ntyp ~= 1
   ind=find(nshh==ntyp);
   eval(iststring{ind});
   
   reply=input('Press E to exit, any other key to continue\n\n','s');
   if strcmp(reply,'E') | strcmp(reply,'e')
   return
   end
   end
      
   fseek(fid,posinif+len,'bof');
   end
   
   if isempty(find(ntyp == nshh))
      fprintf('\nThere are no structures of type %d in file %s \n',ntyp,file);
   end
   
   
   end     
   
   if sel == 6  % Structure sequence raw
      fprintf('\n\nStructure class ->Length \n');
      jj=0;
      while class ~= classfreof
   jj=jj+1;      
   posinif=ftell(fid);
   len=fread(fid,1,'uint32');
   class=fread(fid,1,'uint16');
   fprintf(' %3d ->%7d   ',class,len);
   if jj == 5
      fprintf('\n');
      jj=0;
   end
   
   fseek(fid,posinif+len,'bof');
   end
   
   fprintf('\n');
   
end
   
   if sel == 7  % Structure sequence analytical
      swp=0;
      jj=0;
      jjj=0;
      while class ~= classfreof
      posinii=ftell(fid);
      len=fread(fid,1,'uint32');
      posinif=posinii+len;
      class=fread(fid,1,'uint16');
               
      if class == 1
      k=fread(fid,1,'uint16');
      namefr=fmnl_read_string(fid);
      classtype=fread(fid,1,'uint16');
      x=strmatch(cellstr(namefr),listsh,'exact');
      nsh(x)=classtype;
      numsr(1)=numsr(1)+1;
      fprintf('\nDictionary Structure for %s \n',namefr);        
      elseif class ~= nsh(1)
      [nsh,numsr]=fmnl_switstr(fid,len,class,swp,listsh,nsh,numsr,file);
      fprintf(' %3d ->%7d    ',class,len);
      jj=jj+1;
      if jj == 5
         fprintf('\n');
         jj=0;
      end
      
      else
      k=fread(fid,1,'uint16');
      namefrh=fmnl_read_string(fid);
      run=fread(fid,1,'int32');
      frame=fread(fid,1,'uint32');
      dataq=fread(fid,1,'uint32');
      gts=fread(fid,1,'uint32');
      gtn=fread(fid,1,'uint32');
      
      fprintf('\nNew frame  %d  - %d %d \n',frame,gts,gtn);
      end
   
      fseek(fid,posinif,'bof');
      end
      
      fprintf('\n\nOpen file -- > %s \n',file);
      fprintf('\nStructure name \t Structure class \t Number of Structures\n');
      fprintf('%14s \t %15d \t %d\n','SH',1,numsr(1));
      fprintf('%14s \t %15d \t %d\n','SE',2,numsr(2));
      for j=1:17
         fprintf('%14s \t %15d \t %d \n',char(listsh{j}),nsh(j),numsr(j+2));
      end 
      
   end   
      
   if sel == 8  % Show FrVect
      swp=0;
      while class ~= classfreof
      posinii=ftell(fid);
      len=fread(fid,1,'uint32');
      posinif=posinii+len;
      class=fread(fid,1,'uint16');
      
      if class ~= nsh(12)
      [nsh,numsr]=fmnl_switstr(fid,len,class,swp,listsh,nsh,numsr,file);
      else
      frvect.structureClass=class;
      frvect.occurrence=fread(fid,1,'uint16');
      frvect.length=len;
      frvect.frvectorname=fmnl_read_string(fid);
      frvect.compression=fread(fid,1,'uint16');
      frvect.datatype=fread(fid,1,'uint16');
      frvect.ndata=fread(fid,1,'uint32'); 
      
      frvect.nbytes=fread(fid,1,'uint32');
      if frvect.compression == 0 | frvect.compression == 256
      typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64'...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'};
      type=typedata{frvect.datatype+1};   
      frvect.data=fread(fid,frvect.ndata,type);
      else
         frvect.data=fread(fid,frvect.nbytes,'ubit8');
      end
      
      frvect.ndim=fread(fid,1,'uint32');
      frvect.nx=fread(fid,frvect.ndim,'uint32');
      frvect.dx=fread(fid,frvect.ndim,'float64');
      frvect.startx=fread(fid,frvect.ndim,'float64');
      for i=1:frvect.ndim
      frvect.unitx{i}=fmnl_read_string(fid);
      end
      frvect.unity=fmnl_read_string(fid);
      frvect
      if frvect.compression == 0 | frvect.compression == 256
      ans=input('Plot it ?  Y/N or E to exit: ','s');
        if isempty(ans)
        ans='N';
        end
        if ans == 'y' | ans == 'Y'
        figure;
        x=(1:frvect.ndata)*frvect.dx;
        plot(x,frvect.data);
        elseif ans == 'e' | ans == 'E'
        return
        end
      else
      reply=input('Compressed Data. Press E to exit, any other key to continue\n','s');
       if strcmp(reply,'E') | strcmp(reply,'e')
       return
       end
      end
      
      end
   
      fseek(fid,posinif,'bof');   
   end
   
end
