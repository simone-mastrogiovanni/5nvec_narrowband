function [vec,tim0,buf,tim0buf,interrupt,sds_,holes]=interlace_sds(buf,tim0buf,interrupt,sds_,chn,len,len0,alpers)
%INTERLACE_SDS fills interlaced (by len0, e.g. len0=len/2) vec with data from sds files
%
% It uses vec_from_sds. len0 must be < len and >= len/2.
%
% The variables buf,tim0buf,interrupt, sds_ are input and output.
%
% At beginning, buf, that contains the last data read, should be of length len0 and
% filled by zeros (or other, if needed); interrupt must be
% set to 2 (normally it is 0, in case of data interruption is set to 1).
% The information for the holes is for buf.
% When there is discontinuity in data, the last buf is not served (the last vec is ended
% with zeros) and interrupt is set to 1, so the next vec starts as at beginning and 
% the last buf is used, not read.
%
% Operation:
%
%   At each call a vec of length len is produced. It contains len0 new
%   data. The interlacing is len-len0.
%   The first vec produced (start vec) has the first len1 = len-len0 data null.
%   Any interruption (not simply hole), the vec is filled by zeros (tail vec) and at the 
%   next call a new start vec is produced.

% Interrupt:
%
%     2     beginning (no check for continuity)
%     0     no interruption (normal)
%     1     interrupted: when a call is interrupted, in output last chunk is zeros, 
%           then the following call restarts with the last buffer, no read

% Times:
%
%     tim0     vec time (input old, output new)
%     tim0buf  buf time (input old, output new) : used for 

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('alpers')
    alpers=0;
end

len1=len-len0;
tim0buflast=tim0buf;

if interrupt == 1 % new start, using old buf
    vec(1:len1)=0;
    vec(len1+1:len)=buf;
    tim0=tim0buf-sds_.dt*len1/86400;
    interrupt=0;
    holes=0;
    return;
elseif interrupt == 2 % start
    buf(1:len0)=0;
end

vec(1:len1)=buf(len0-len1+1:len0);
[buf,sds_,tim0buf,holes]=vec_from_sds(sds_,chn,len0,alpers);

DT=(tim0buf-tim0buflast)*86400-len0*sds_.dt;

if interrupt == 0
    if abs(DT) > sds_.dt
        str=sprintf(' ---> interlacing hole %f s',DT);
        disp(str);
        vec(len1+1:len)=0;
        tim0=tim0buflast+sds_.dt*len0/86400;
        interrupt=1;
        return;
    end
end

vec(len1+1:len)=buf;
tim0=tim0buf-sds_.dt*len1/86400;
interrupt=0;
