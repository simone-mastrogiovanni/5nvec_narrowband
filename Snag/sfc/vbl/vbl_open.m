function vbl_=vbl_open(file)
%VBL_OPEN   open an existing vbl file and initialize the vbl structure
%
%                        VBL file format
%
%   *** VBL is one of the file formats of the SFC collection ***
%
% The vbl (Variable block data format) format is intended for storing one or more data
% sets by means of "blocks" composed of sub-blocks, in a variety of different cases.
% The base structure is similar to the SBL format, the unique difference is
% that every sub-block array is preceded by a label as  [CHxxxxxx] and two
% int32 with the two dimensions of the array (plus the inix and iniy as in
% SBL). At the end an "index" with the pointers to the blocks may be
% present.
% 
% The format is the following :
%
%  label        - 8 bytes string (1-8)        #SFC#VBL
%
% First 944 bytes : see the sfc_open function. Then the ch description,
% identical to the sbl format, except the lenx and leny parameters that are
% variable block by block.
%
%  ch()         - N*128 bytes structures       names and captions for the channels
%      .dx      - double (1-8)                 sampling first dimension (if any, otherwise 0)
%      .dy      - double (9-16)                sampling second dimension (if any, otherwise 0)
%      .lenx    - int32  (17-20)               0
%      .leny    - int32  (21-24)               0
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
% The vbl_ structure derives from the sfc_ structure. 
% The added or modified members are:
%
%   vbl_.ch(nch)      channel structures
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
%   vbl_.len          number of blocks
%   vbl_.point(nch)   pointer for next data
%   vbl_.nextblock    pointer to next block
%
%
%                     Structure of the blocks
%
% All blocks have the same structure.
% Each block is composed by "channels" (or sub-blocks), containing a short
% header and data, in the following way:
%
%      block number             (a 16 byte string as "[BLNxxxxxxxxxxx]")
%      block time               (double; may be not meaningful)
%      pointer to next block	int64 (may be 0)
%
%      ch number    (a 8 byte string as "[CHxxxx]")
%      ch(1).dx     double; always present; may be not meaningful 
%      ch(1).dy     double; always present; may be not meaningful
%      ch(1).lenx	int32
%      ch(1).leny	int32
%      ch(1).inix	double; always present; may be not meaningful
%      ch(1).iniy	double; always present; may be not meaningful
%      ch(1).type	double; always present; may be not meaningful
%      ch(1).par1	special data type specific; absent for standard data
%      ch(1).par2	special data type specific; absent for standard data
%      ...
%      A(lenx,leny)   data of channel 1
%
% then the same for channel 2 and so on.
%
% At the end, after all blocks, may be present a block index, with the following
% structure:
%
%     pointer to bl 1           8 byte integer
%     pointer to bl 2           8 byte integer
%         ...                       ...
%     total number of blocks    8 byte integer
%     [-INDEX]                  8 byte string
%
% The length of the index is (Nbl+2)*8 bytes.

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

vbl_=sfc_open(file);
vbl_.nextblock=0;
fid=vbl_.fid;
if fid == -1
    disp(sprintf('Non-existing file %s  \r\n',file));
    vbl_.eof=2;
    return
end

for i = 1:vbl_.nch
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
end

vbl_.ch=ch;

fseek(fid,vbl_.point0,'bof');

vbl_.point=vbl_.point0;
vbl_.eof=0;

if vbl_.len == 0
    disp(' *** Number of vbl blocks not known')
end