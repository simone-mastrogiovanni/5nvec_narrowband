function [d,sds_]=sds2ds(d,sds_,chn)
%SDS2DS  generates a data-stream from an sds file 
%
% This is a ds server.
%
%    chn    the number of the channel
%
%        [d,sds_]=sds2ds(d,chn,sds_)
%
% Operation:
%
% if d.lcw == 0 -> initializes
% if d.lcw ~= d.lcr exits
% if d.lcw < d.lcr  error
% if d.lcw > d.lcr  warning
%
% 
%  Interlaced operation:
% 
% chunk 1 y1   0 1 1 1 | 
% chunk 2 y2   1 1 2 2 |
% chunk 3 y1   2 2 3 3 |   
% chunk 4 y2   3 3 4 4 |
% chunk 5 y1   4 4 5 5 |
% chunk 6 y2   5 5 6 6 |
%
% In the case of interlaced operations, the data are shifted of len/4:
% the first len/4 data are set to 0;
% this because to not overlook the beginning data.

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=d.len;
len2=floor(len/2);
len4=floor(len2/2);

if d.lcw == 0
   d.cont=0;
   d.capt='from sds file';
end

%fseek(sds_.fid,sds_.point,'bof');

odd=1;
d.lcw=d.lcw+1;
if floor(d.lcw/2)*2 == d.lcw
    odd=0;
end
if odd == 1
    d.nc1=d.nc1+1;
else
    d.nc2=d.nc2+1;
end

if d.type == 2
    if odd == 1 
        if d.lcw == 1
            vec(1:len4)=0;
            [vec(len4+1:len),sds_]=vec_from_sds(sds_,chn,len4*3);
        else
            vec(1:len2)=d.y2(len2+1:len);
            [vec1,sds_]=vec_from_sds(sds_,chn,len2);
            if sds_.eof < 2
                vec(len2+1:len)=vec1;
            else
                return
            end
        end
        d.y2=d.y1;
        d.y1(1:len)=vec;
        d.nc1=d.nc1+1;
        d.totdat=d.totdat+len2;
    else
        vec(1:len2)=d.y1(len2+1:len);
        [vec1,sds_]=vec_from_sds(sds_,chn,len2);
        if sds_.eof < 2
            vec(len2+1:len)=vec1;
        end
        d.y1=d.y2;
        d.y2(1:len)=vec;
        d.nc2=d.nc2+1;
        d.totdat=d.totdat+len2;
    end
else
    if d.type == 1
        d.y2=d.y1;
    end
    
    [vec,sds_]=vec_from_sds(sds_,chn,len);
    if vec == -1
        return
    end
    d.y1=vec;
    d.totdat=d.totdat+len;
end

if d.verb > 0
    s=sprintf('%d chunk  - %d total data',d.lcw,d.totdat);
    disp(s);
end
