function dds_=dds_open(file,pers)
%dds_OPEN   opens an existing dds file and initialize the dds structure;
%           if pers (periods) is specified, opens the first file with data in
%           one of the defined ranges; in this case the operation is logged.
%
%    file        file to open
%    pers        (n,2) array containing the start and stop time of the n periods.
%                It is omitted or 0 if there are no selection periods. If pers is
%                in action, the operation is logged on dds.log .
%
%    dds_        dds structure
%
%                        dds file format
%
%   *** dds is one of the file formats of the SFC collection ***
%
% The dds (Simple DS) format is intended for storing one or more data
% streams, with the same time beginning and the same sampling time.
% 
% The format is the following :
%
%  label    - 8 bytes string (1-8)         #SFC#DDS
%
% First 944 bytes : see the sfc_open function.
%
%  ch()     - N*128 bytes strings          names and captions for the channels
%  user     - (free)                       user header
%  data     - N*8*len bytes double          the data (l for each channel; double)
%
% To access the user header, fseek(fid,944+N*128,'bof')
%
% The dds_ structure derives from the sfc_ structure.
% The added or modified members are:
%
%   dds_.ch(nch)   channel captions
%   dds_.len       length of a stream (the total number of data is len*nch)
%   dds_.point     pointer for next data
%
% A particular type of dds file is the t-type in which the first channel is
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
        fidlog=fopen('dds.log','w');
    end
end

ck0=0;

while ck0 == 0
    dds_=sfc_open(file);
    fid=dds_.fid;
    ck0=5;
	if fid == -1
        if noper == 0
            fprintf(fidlog,'Non-existing file %s  \r\n',file);
            fclose(fidlog);
        end
        return
	end
	if dds_.len == 0
        fseek(fid,0,'eof');
        len=ftell(fid);
         dds_.len=(len-dds_.point0)/(dds_.nch*8);
        fseek(fid,dds_.point0-dds_.nch*128,'bof');
	end
    for i = 1:dds_.nch
        ch=fread(fid,128,'char');
        dds_.ch{i}=blank_trim(char(ch'));
	end
	
	fseek(fid,dds_.point0,'bof');
	
	dds_.point=dds_.point0;
    if noper == 0
        fprintf(fidlog,'Open %s at %s \r\n',dds_.file,datestr(now));
        tim0=dds_.t0;
        tim1=tim0+dds_.len*dds_.dt/86400;
        ck0=dds_check_time(tim0,tim1,pers); %,tim0,tim1,pers
        if ck0 == 0
            fclose(dds_.fid);
            file=[dds_.pnam dds_.filspost];
            if strcmp(dds_.filspost,'#NOFILE')
                dds_.eof=2;
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

dds_.eof=0;
