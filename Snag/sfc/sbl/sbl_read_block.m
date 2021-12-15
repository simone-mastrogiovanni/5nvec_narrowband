function [M,t,blhead]=sbl_read_block(sbl_,chn,indmin,indmax)
%READ_SBL   reads data from a block of a sbl file 
%           the file should be opened at the beginning
%
%        see also sbl_read_kblock
%
%        ONLY FOR ONE DIMENSION ARRAYS
%
%    sbl_       input file header
%    chn        channel numbers array
%    indmin     min index array (if 0 all; if absent, all for all channels)
%    indmax     max index array
%
%    M          output data cell array

% Version 2.0 - January 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
    
pos0=ftell(sbl_.fid);

sta=fseek(sbl_.fid,pos0+2,'bof');
if sta < 0
    disp('end of file ');
    M=0;
    t=0;
    blhead='No block';
    return
end

lenbl=sbl_.blen;

nch=length(chn);

if ~exist('indmin','var')
    indmin=zeros(1,nch);
    indmax=indmin;
end

ndat=indmax-indmin+1;

M=cell(nch,1);

fseek(sbl_.fid,pos0,'bof');
blhead=fscanf(sbl_.fid,'%16c',1);
t=fread(sbl_.fid,1,'double');

for i = 1:nch
    if indmin(i) == 0
        indmin(i)=1;
        inmax(i)=sbl_.ch(chn(i)).lenx;
        ndat(i)=inmax(i);
    end
    typ=sbl_.ch(chn(i)).type;
    bias1=sbl_.ch(chn(i)).bias;
    bias=pos0+bias1;
    
    switch typ
        case 1
            fseek(sbl_.fid,bias+indmin(i)-1,'bof');
            c=fread(sbl_.fid,ndat(i),'uchar');
            M{i}=c.';
        case 2
            fseek(sbl_.fid,bias+(indmin(i)-1)*2,'bof');
            c=fread(sbl_.fid,ndat(i),'int16');
            M{i}=c.';
        case 3
            fseek(sbl_.fid,bias+(indmin(i)-1)*4,'bof');
            c=fread(sbl_.fid,ndat(i),'int32');
            M{i}=c.';
        case 4
            fseek(sbl_.fid,bias+(indmin(i)-1)*4,'bof');
            c=fread(sbl_.fid,ndat(i),'float32');
            M{i}=c.';
        case 5
            fseek(sbl_.fid,bias+(indmin(i)-1)*8,'bof');
            c=fread(sbl_.fid,2*ndat(i),'float32');
            if length(c) > 0
                c=c(1:2:2*ndat(i))+1i*c(2:2:2*ndat(i));
                M{i}=c.';
            else
                t=0;
            end
        case 6
            fseek(sbl_.fid,bias+(indmin(i)-1)*8,'bof');
            c=fread(sbl_.fid,ndat(i),'double');
            M{i}=c.';
        case 7
            fseek(sbl_.fid,bias+(indmin(i)-1)*16,'bof');
            c=fread(sbl_.fid,2*ndat(i),'double');
            if length(c) > 0
                c=c(1:2:2*ndat(i))+1i*c(2:2:2*ndat(i));
                M{i}=c.';
            else
                t=0;
            end
    end
end        
    
fseek(sbl_.fid,pos0+lenbl,'bof');
