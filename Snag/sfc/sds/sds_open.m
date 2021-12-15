function sds_=sds_open(file,pers)
%SDS_OPEN   opens an existing sds file and initialize the sds structure;
%           if pers (periods) is specified, opens the first file with data in
%           one of the defined ranges; in this case the operation is logged.
%
%    file        file to open
%    pers        (n,2) array containing the start and stop time of the n periods.
%                It is omitted or 0 if there are no selection periods. If pers is
%                in action, the operation is logged on sds.log .
%
%    sds_        sds structure
%
%                        SDS file format
%
%   *** SDS is one of the file formats of the SFC collection ***
%
% The SDS (Simple DS) format is intended for storing one or more data
% streams, with the same time beginning and the same sampling time.
% 
% The format is the following :
%
%  label    - 8 bytes string (1-8)         #SFC#SDS
%
% First 944 bytes : see the sfc_open function.
%
%  ch()     - N*128 bytes strings          names and captions for the channels
%  user     - (free)                       user header
%  data     - N*4*len bytes float          the data (l for each channel; float)
%
% To access the user header, fseek(fid,944+N*128,'bof')
%
% The sds_ structure derives from the sfc_ structure.
% The added or modified members are:
%
%   sds_.ch(nch)   channel captions
%   sds_.len       length of a stream (the total number of data is len*nch)
%   sds_.point     pointer for next data
%
% A particular type of sds file is the t-type in which the first channel is
% a time abscissa (normally in days).It is recognized by the channel
% caption that begins with "timing channel".

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

noper=1; % no observation periods considered 
if exist('pers')
    if length(pers) > 1
        noper=0; % observation periods considered 
        fidlog=fopen('sds.log','w');
    end
end

ck0=0;

while ck0 == 0
    sds_=sfc_open(file);
    fid=sds_.fid;
    ck0=5;
	if fid == -1
        if noper == 0
            fprintf(fidlog,'Non-existing file %s  \r\n',file);
            fclose(fidlog);
        end
        return
	end
	if sds_.len == 0
        fseek(fid,0,'eof');
        len=ftell(fid);
%         len=0;
%         l=1000;
%         while l == 1000
%             [a,l]=fread(fid,1000,'float');
%             len=len+l;
%         end
         sds_.len=(len-sds_.point0)/(sds_.nch*4);
        fseek(fid,sds_.point0-sds_.nch*128,'bof');
	end
    for i = 1:sds_.nch
        ch=fread(fid,128,'char');
        sds_.ch{i}=blank_trim(char(ch'));
	end
	
	fseek(fid,sds_.point0,'bof');
	
	sds_.point=sds_.point0;
    if noper == 0
        fprintf(fidlog,'Open %s at %s \r\n',sds_.file,datestr(now));
        tim0=sds_.t0;
        tim1=tim0+sds_.len*sds_.dt/86400;
        ck0=sds_check_time(tim0,tim1,pers); %,tim0,tim1,pers
        if ck0 == 0
            fclose(sds_.fid);
            file=[sds_.pnam sds_.filspost];
            if strcmp(sds_.filspost,'#NOFILE')
                sds_.eof=2;
                str=sprintf(' --------> End of files');
                disp(str);
                fprintf(fidlog,' End of files at %s ',datestr(now));
            end
        end
    end
end

if noper == 0
    fclose(fidlog);
end

sds_.eof=0;
