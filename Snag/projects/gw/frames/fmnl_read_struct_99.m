function fst=fmnl_read_struct(fid,struct_num)
%FMNL_READ_STRUCT  reads a frame structure
%
%      fst=fmnl_read_struct(fid,struct_num)
%
%      fid          ...
%      struct_num   structure number from dictionary; refers to the
%                   following strnam:
%
%    strnam{1}='FrameH ';
%    strnam{2}='FrAdcData ';
%    strnam{3}='FrDetector ';
%    strnam{4}='FrEndOfFrame ';
%    strnam{5}='FrMsg ';
%    strnam{6}='FrHistory ';
%    strnam{7}='FrRawData ';
%    strnam{8}='FrProcData ';
%    strnam{9}='FrSimData ';
%    strnam{10}='FrSerData ';
%    strnam{11}='FrStatData ';
%    strnam{12}='FrVect ';
%    strnam{13}='FrTrigData ';
%    strnam{14}='FrSummary ';
%    strnam{15}='FrEndOfFile ';
%    strnam{16}='FrFileMark ';
%
%      fst             the read structure
%         .len         length in bytes
%         .classtype   type of the structure
%         .k           serial number

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

pos=ftell(fid);

fst.len=fread(fid,1,'uint32');
fst.classtype=fread(fid,1,'uint16');
fst.k=fread(fid,1,'uint16');

frstrlen=fst.len;
if isempty(fst.classtype)
   fst.classtype=0;
   fst.len=0;
   fst.k=0;
   return
end

if fst.classtype < 17 & fst.classtype > 0
   %fst.classtype,struct_num
	if struct_num(fst.classtype) <= 0
      struct_num(fst.classtype)=fst.classtype;
 %     disp('Problems with the dictionary');
   end
end

switch fst.classtype
case 1
   fst.name=fmnl_read_string(fid);
   fst.class=fread(fid,1,'uint16');
   fst.comment=fmnl_read_string(fid);
case 2
   fst.name=fmnl_read_string(fid);
   fst.class=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
case struct_num(1)    % FrameH
   fst.name=fmnl_read_string(fid);
   fst.run=fread(fid,1,'uint32');
   fst.frame=fread(fid,1,'uint32');
   fst.gps_s=fread(fid,1,'uint32');
   fst.gps_n=fread(fid,1,'uint32');
   fst.leap=fread(fid,1,'uint16');
   fst.loctim=fread(fid,1,'int32');
   fst.frtlen=fread(fid,1,'float64');
   fst.type=fread(fid,1,'int32');
   fst.user=fread(fid,1,'uint32');
   fst.detectsim=fread(fid,1,'uint32');
   fst.detectproc=fread(fid,1,'uint32');
   fst.history=fread(fid,1,'uint32');
   fst.rawdata=fread(fid,1,'uint32');
   fst.procdata=fread(fid,1,'uint32');
   fst.strain=fread(fid,1,'uint32');
   fst.simdata=fread(fid,1,'uint32');
   fst.trigdata=fread(fid,1,'uint32');
   fst.summarydata=fread(fid,1,'uint32');
   fst.auxdata=fread(fid,1,'uint32');
case struct_num(2)   % FrAdcData
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.crate=fread(fid,1,'uint32');
   fst.channel=fread(fid,1,'uint32');
   fst.nbits=fread(fid,1,'uint32');
   fst.bias=fread(fid,1,'float32');
   fst.slope=fread(fid,1,'float32');
   fst.units=fmnl_read_string(fid);
   fst.samprate=fread(fid,1,'float64');
   fst.timoffS=fread(fid,1,'uint32');
   fst.timoffN=fread(fid,1,'uint32');
   fst.fshift=fread(fid,1,'float64');
   fst.overrange=fread(fid,1,'int16');
   fst.data=fread(fid,1,'uint32');
   fst.aux=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(3)   % FrDetector
   fst.name=fmnl_read_string(fid);
   fst.longD=fread(fid,1,'int16');
   fst.longM=fread(fid,1,'int16');
   fst.longS=fread(fid,1,'float32');
   fst.latD=fread(fid,1,'int16');
   fst.latM=fread(fid,1,'int16');
   fst.latS=fread(fid,1,'float32');
   fst.elev=fread(fid,1,'float32');
   fst.armXaz=fread(fid,1,'float32');
   fst.armYaz=fread(fid,1,'float32');
   fst.armlen=fread(fid,1,'float32');
   fst.more=fread(fid,1,'uint32');
case struct_num(4)   % FrEndOfFrame
   fst.run=fread(fid,1,'uint32');
   fst.frame=fread(fid,1,'uint32');
case struct_num(5)   % FrMsg
   fst.alarm=fmnl_read_string(fid);
   fst.message=fmnl_read_string(fid);
   fst.severity=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(6)   % FrHistory
   fst.name=fmnl_read_string(fid);
   fst.time=fread(fid,1,'uint32');
   fst.comment=fmnl_read_string(fid);
   fst.next=fread(fid,1,'uint32');
case struct_num(7)   % FrRawData
   fst.name=fmnl_read_string(fid);
   fst.firstser=fread(fid,1,'uint32');
   fst.firstadc=fread(fid,1,'uint32');
   fst.logmsg=fread(fid,1,'uint32');
   fst.more=fread(fid,1,'uint32');
case struct_num(8)   % FrProcData
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.samplerate=fread(fid,1,'float64');
   fst.timeoffsetS=fread(fid,1,'uint32');
   fst.timeoffsetN=fread(fid,1,'uint32');
   fst.fshift=fread(fid,1,'float64');
   fst.data=fread(fid,1,'uint32');
   fst.aux=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(9)   % FrSimData
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.samplerate=fread(fid,1,'float64');
   fst.data=fread(fid,1,'uint32');
   fst.input=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(10)  % FrSerData
   fst.name=fmnl_read_string(fid);
   fst.timesec=fread(fid,1,'uint32');
   fst.timensec=fread(fid,1,'uint32');
   fst.samplerate=fread(fid,1,'float32');
   fst.data=fmnl_read_string(fid);
   fst.serial=fread(fid,1,'uint32');
   fst.more=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(11)  % FrStatData
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.timestart=fread(fid,1,'uint32');
   fst.timeend=fread(fid,1,'uint32');
   fst.version=fread(fid,1,'uint32');
   fst.detector=fread(fid,1,'uint32');
   fst.data=fread(fid,1,'uint32');
case struct_num(12)  % FrVect
   fst.name=fmnl_read_string(fid);
   fst.compress=fread(fid,1,'int16');
   fst.type=fread(fid,1,'int16');
   fst.ndata=fread(fid,1,'uint32');
   fst.nbytes=fread(fid,1,'uint32');
   if fst.compress == 0
   	switch fst.type
   	case 0
      	fst.data=fread(fid,fst.ndata,'uchar');
   	case 1
      	fst.data=fread(fid,fst.ndata,'int16');
   	case 2
      	fst.data=fread(fid,fst.ndata,'float64');
   	case 3
      	fst.data=fread(fid,fst.ndata,'float32');
   	case 4
      	fst.data=fread(fid,fst.ndata,'int32');
   	case 5
      	fst.data=fread(fid,fst.ndata,'int64');
   	case 6
      	fst.data=fread(fid,2*fst.ndata,'float32');
   	case 7
      	fst.data=fread(fid,2*fst.ndata,'float64');
   	case 8
   	case 9
      	fst.data=fread(fid,fst.ndata,'uint16');
   	case 10
      	fst.data=fread(fid,fst.ndata,'uint32');
   	case 11
      	fst.data=fread(fid,fst.ndata,'uint64');
   	case 12
      end
   else
      fst.comprdata=fread(fid,fst.nbytes,'uchar');
       % mettere qui la decompressione e produrre fst.data
   end
   fst.ndim=fread(fid,1,'uint32');
   if fst.ndim > 0 & fst.ndim < 5
   	fst.nx=fread(fid,fst.ndim,'uint32');
   	fst.dx=fread(fid,fst.ndim,'float64');
   	fst.unitx=fmnl_read_string(fid);  % not correct
   	fst.unity=fmnl_read_string(fid);
      fst.next=fread(fid,1,'uint32');
   end
case struct_num(13)  % FrTrigData
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.inputs=fmnl_read_string(fid);
   fst.gtimeS=fread(fid,1,'uint32');
   fst.gtimeN=fread(fid,1,'uint32');
   fst.bvalue=fread(fid,1,'uint32');
   fst.rvalue=fread(fid,1,'float32');
   fst.prob=fread(fid,1,'float32');
   fst.stat=fmnl_read_string(fid);
   fst.data=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(14)  % FrSummary
   fst.name=fmnl_read_string(fid);
   fst.comment=fmnl_read_string(fid);
   fst.test=fmnl_read_string(fid);
   fst.moments=fread(fid,1,'uint32');
   fst.next=fread(fid,1,'uint32');
case struct_num(15)  % FrEndOfFile
   fst.nframes=fread(fid,1,'uint32');
   fst.nbytes=fread(fid,1,'uint32');
   fst.chkflag=fread(fid,1,'uint32');
   fst.chksum=fread(fid,1,'uint32');
case struct_num(16)  % FrFileMark
end

fseek(fid,pos+frstrlen,'bof');