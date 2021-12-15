function adcdata=fmnl_extrfradc(fid,nframe,posfradc,nadc,chosfr)

fseek(fid,posfradc,'bof');

for i=1:nadc
   adcdata.name{i}=fmnl_read_string(fid);
end

adcdata.channid=fread(fid,nadc,'int32');
adcdata.groupid=fread(fid,nadc,'int32');
[sel,ok]=listdlg('PromptString',{'Select ADCData from List:' ''},...
   'Name','ADCData Explorer',... 
   'selectionmode','single',...
   'ListSize',[260,400],...
   'Liststring',adcdata.name);
if ok == 0
   return
end

blk=8*nframe*(sel-1);
fseek(fid,blk,'cof'); % Set pointer to channel chosen in 'sel'
distch=fread(fid,nframe,'uint64');

for i=1:nframe
   
fseek(fid,distch(i),'bof'); % Set pointer to ADCdata
lenfradc=fread(fid,1,'uint32'); % Read AdcData Header length
fseek(fid,lenfradc-42,'cof'); % Go to samprate variable
adcdata.samprate=fread(fid,1,'float64');
fseek(fid,30,'cof'); %Go to FrVect(AdcData)
lendata=fread(fid,1,'uint32'); % Read FrVect(ADCdata) length
fseek(fid,4,'cof');
adcdata.name=fmnl_read_string(fid);
adcdata.compress=fread(fid,1,'uint16');
if adcdata.compress == 0
   adcdata.type=fread(fid,1,'uint16');
   adcdata.ndata=fread(fid,1,'uint32');
   if i == 1
      adcdata.data=(1:nframe*adcdata.ndata)';
      a=zeros(adcdata.ndata,nframe);
      b=(1:(nframe*adcdata.ndata));
      a([b])=b;
   end
   
   adcdata.nbytes=fread(fid,1,'uint32');
   typedata={'uchar' 'int16' 'float64' 'float32' 'int32' 'int64'...
         'float32' 'float64' 'uint16' 'uint16' 'uint32' 'uint64'}; % Warning for complex values
   adcdata.data(a(:,i))=fread(fid,adcdata.ndata,typedata{adcdata.type+1});
   adcdata.ndim=fread(fid,1,'uint32');
   adcdata.nx=fread(fid,adcdata.ndim,'uint32');
   adcdata.dx=fread(fid,adcdata.ndim,'float64');
   adcdata.startx=fread(fid,adcdata.ndim,'float64');
   adcdata.unitx=fmnl_read_string(fid);
   adcdata.unity=fmnl_read_string(fid);
   adcdata.next=fread(fid,1,'uint32');
else
   fprintf('Compressed Data \nCompression type: %d \n',adcdata.compress);
end
end