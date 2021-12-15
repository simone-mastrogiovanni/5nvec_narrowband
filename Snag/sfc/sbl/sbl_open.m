function sbl_=sbl_open(file)
%SBL_OPEN   open an existing sbl file and initialize the sbl structure
%
%                        SBL file format
%
%   *** SBL is one of the file formats of the SFC collection ***
%
% The SBL (Simple block data format) format is intended for storing one or more data
% sets by means of "blocks" composed of sub-blocks, in a variety of different cases.
% 
% The format is the following :
%
%  label        - 8 bytes string (1-8)        #SFC#SBL
%
% First 944 bytes : see the sfc_open function.
%
%  ch()         - N*128 bytes structures       names and captions for the channels
%      .dx      - double (1-8)                 sampling first dimension (if any, otherwise 0)
%      .dy      - double (9-16)                sampling second dimension (if any, otherwise 0)
%      .lenx    - int32  (17-20)               length first dimension (number of rows)
%      .leny    - int32  (21-24)               length second dimension (for single dim arrays, 1)
%      .type    - int32  (25-28)               type of data:
%                                                 1   byte
%                                                 2   int16
%                                                 3   int32
%                                                 4   float
%                                                 5   float complex
%                                                 6   double
%                                                 7   double complex
%                                                ..   compressed formats   
%      .name    - 100 bytes string (29-128)    name or caption
%
%  user         - (free)                       user header
%
%  data blocks  - ....                         the data (l for each channel; float)
%
% To access the user header, fseek(fid,944+N*128,'bof')
%
% The sbl_ structure derives from the sfc_ structure.
% The added or modified members are:
%
%   sbl_.ch(nch)      channel structures
%          .dx
%          .dy
%          .lenx      number of rows
%          .leny      number of columns
%          .type      data type of the channel
%          .name      channel name or caption
%          .len       length of the sub-block (in bytes)
%          .inix      initial value of the first abscissa
%          .iniy      initial value of the second abscissa
%          ....       other (depending by the data types)
%          .bias      position of the first data of the block (in bytes)
%          .k         number of read data (pointer to the next data)
%   sbl_.len          number of blocks
%   sbl_.blen         block length (in bytes)
%   sbl_.point(nch)   pointer for next data
%
%
%                     Structure of the blocks
%
% All blocks have the same length and structure.
% Each block is composed by "channels" (or sub-blocks), containing a short
% header and data, in the following way:
%
%      block number (a 16 byte string as "[BLNxxxxxxxxxxx]")
%      block time   (double; may be not meaningful)
%
%      ch(1).inix (always present; may be not meaningful)
%      ch(1).iniy (always present; may be not meaningful)
%      ch(1).par1 (data type specific; may be absent)
%      ch(1).par2 (data type specific; may be absent)
%      ...
%      A(lenx,leny)   data of channel 1
%
% then the same for channel 2 and so on.

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sbl_=sfc_open(file);
fid=sbl_.fid;
blen=24;
if fid < 0
    fprintf(' *** Error opening file %s \n',file)
end

for i = 1:sbl_.nch
    ch(i).dx=fread(fid,1,'double');
    ch(i).dy=fread(fid,1,'double');
    ch(i).lenx=fread(fid,1,'int32');
    ch(i).leny=fread(fid,1,'int32');
    ch(i).inix=fread(fid,1,'double');
    ch(i).iniy=fread(fid,1,'double');
    ch(i).type=fread(fid,1,'int32');
    name=fread(fid,84,'char');
    ch(i).capt=blank_trim(char(name'));
    ch(i).name=strtok(ch(i).capt);
    ch(i).k=0;
    
    typ=ch(i).type;
    
    switch typ
        case 1
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny;
        case 2
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*2;
        case 3
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*4;
        case 4
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*4;
        case 5
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*8;
        case 6
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*8;
        case 7
            hbl=16;
            blen1=hbl+ch(i).lenx*ch(i).leny*16;
        otherwise
            str=sprintf(' *** Case %d not implemented',typ);
            error(str)
            sbl_.eof=3;
            return
    end
    ch(i).bias=blen+hbl;
    blen=blen+blen1;
end

sbl_.ch=ch;
sbl_.blen=blen;

fseek(fid,sbl_.point0,'bof');

sbl_.point=sbl_.point0;
sbl_.eof=0;

if sbl_.len == 0
    len=0;
    l=1000;
    while l == 1000
        [a,l]=fread(fid,1000,'char');
        len=len+l;
    end
    sbl_.len=len/sbl_.blen;
    fseek(fid,sbl_.point,'bof');
end