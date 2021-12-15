function ch=fmnl_mp_extrfr(mpstruct)

% FMNL_MP_EXTRFR 
%                    This function gets multi channel data
%
%                    mpstruct structure
%                    
%                    ch structure         
%                    
%                       .diff -> Number of frames chosen
%                       .dt -> Sampling time
%                       .name -> Cell array of channels names
%                       .compress -> Compression type
%                       .type -> Data type
%                       .ndata -> Number of data
%                       .data -> Vector data
%                       .nx -> Dimension lengths
%                       .dx -> Scale factors
%                       .unitx -> Units along x coordinate
%                       .unity -> Value of each element

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


nframe=mpstruct.nframe;
fid=mpstruct.fid;

switch mpstruct.chk
   
case 'FrStatData'
case 'FrAdcData'
   
   fseek(fid,mpstruct.posfradc,'bof');
   
   for i=1:mpstruct.nadc
      chname{i}=fmnl_read_string(fid);
   end
   
   fseek(fid,8*mpstruct.nadc,'cof');
   
   [sel,ok]=listdlg('PromptString',{'Select any number of channels' ''},...
   'Name','Multiple channels plot',... 
   'selectionmode','multiple',...
   'ListSize',[260,400],...
   'Liststring',chname);

if ok == 0
   return
end

% Select  Frames

title=sprintf('There are %d frames in this file',mpstruct.nframe);
answ=inputdlg({'Init frame (relative to the file)' 'Number of frames'},...
   title,2,...
  	{'1' '1'});
fr1=eval(answ{1});
nfr=eval(answ{2});
ch.diff=nfr-fr1+1;
jj=2;
%cch{1}='FOLLOWING COMPRESSED DATA WILL NOT BE PLOTTED';
%cch{2}='Null';

%

pos=ftell(fid);

for j=1:length(sel)
   
fseek(fid,pos,'bof');
blk=8*mpstruct.nframe*(sel(j)-1); % Set pointer to channel
fseek(fid,blk,'cof');
fseek(fid,8*(fr1-1),'cof'); % Set pointer to init frame
distch=fread(fid,(nfr-fr1+1),'uint64');

for i=1:(nfr-fr1+1)
   
fseek(fid,distch(i),'bof'); % Set pointer to ADCdata
lenfradc=fread(fid,1,'uint32'); % Read AdcData Header length
fseek(fid,lenfradc-42,'cof'); % Go to samprate variable
samprate=fread(fid,1,'float64');
%%
%Check for FrVect because sometimes FrVect doesn't follow the corresponding FrADC
   fseek(fid,18,'cof');
   id_1=fread(fid,1,'uint16');
   id_2=fread(fid,1,'uint16');
   fseek(fid,8,'cof');
   selc=0;
   indselc=0;
   while selc == 0
   lenchk=fread(fid,1,'uint32');
   cid_1=fread(fid,1,'uint16');
   cid_2=fread(fid,1,'uint16');
   
   if id_1 == cid_1 & id_2 == cid_2
      selc=1;

   else %if
      indselc=indselc+1; 
      lenchk2=lenchk-8; 
      fseek(fid,lenchk2,'cof');
   end %if    
   
   if indselc == 30
       selc=1;
       fprintf('ERROR IN THE FRVECT STRUCTURE POSITION \n CHANNEL NUMBER %d\N',j)
   end
   end %while
%%
%fseek(fid,30,'cof'); %Go to FrVect(AdcData)
%lendata=fread(fid,1,'uint32'); % Read FrVect(ADCdata) length
%fseek(fid,4,'cof');


   cname=fmnl_read_string(fid);
   compress=fread(fid,1,'uint16');

   ch.name{j}=cname;
   ch.dt(j)=(1/samprate);
   ch.compress(j)=compress;
   ch.type(j)=fread(fid,1,'uint16');
   ch.ndata(j)=fread(fid,1,'uint32');
   
   if i == 1 
      ch.data{j}=(1:ch.ndata(j)*(nfr-fr1+1))';
      a=zeros(ch.ndata(j),(nfr-fr1+1));
      b=(1:((nfr-fr1+1)*ch.ndata(j)));
      a([b])=b;
   end
   
   nbytes(j)=fread(fid,1,'uint32');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64'...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'}; % Warning for complex values
   
   if ch.compress(j) == 0
   ch.data{j}(a(:,i))=fread(fid,ch.ndata(j),typedata{ch.type(j)+1});
   else
   unclen=uint32(ch.ndata(j)*nbytes(j));
   comp=fread(fid,nbytes(j),'*uchar');
   complen=uint32(nbytes(j));
   nbtypedata=[1 2 8 4 4 8 4 8 2 2 4 8];
   typ=ch.type(j)+1;
   nbtype=nbtypedata(typ+1);
   ch.data{j}(a(:,i))=(frdecomp(unclen,comp,complen,ch.compress(j),ch.ndata(j),typ,nbtype))';
   end
   
   ch.ndim(j)=fread(fid,1,'uint32');
   ch.nx(j)=fread(fid,ch.ndim(j),'uint32');
   ch.dx(j)=fread(fid,ch.ndim(j),'float64');
   ch.startx(j)=fread(fid,ch.ndim(j),'float64');
   ch.unitx{j}=fmnl_read_string(fid);
   ch.unity{j}=fmnl_read_string(fid);
   
   
   
   end
   end
   
case 'FrProcData'
case 'FrSimData'
case 'FrSerData'
case 'Frsummary'
case 'FrTrigData'
case 'FrSimEvent'
end
