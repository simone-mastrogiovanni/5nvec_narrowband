function [vec,sds_]=vec_from_sds(sds_,chn,len,pers)
%VEC_FROM_SDS  fills vec with data from an sds file
% 
%  If the file ends, opens the following one.
%
%   sds_        sds structure
%   chn         number of the channel
%   len         length
%   pers        (n,2) array containing the start and stop time of the n periods.
%                It is omitted or 0 if there are no selection periods. If pers is
%                in action, the operation is logged on sds.log .

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

noper=1;
if exist('pers')
    if length(pers) > 1
        noper=0;
    end
else
    pers=0;
end

sds_.acc=sds_.acc+1;
sds_.eof=0;
len1=len;
if noper == 0
    pos=ftell(fid);
    ndat=pos-sds_.point0/(sds_.nch*4);
    tim0=sds_.t0+sds_.dt*ndat;
    tim1=tim0+len*sds_.dt;
    [ck,dtim,kper]=sds_check_time(tim0,tim1,pers); % check chunk extrema vs periods
    if ck == 2 | ck == 4 % beginning of chunk external
        kk=round((pers(kper,1)-tim0)/sds_.dt)*(4*sds_.nch)+pos;
        fseek(fid,kk,'bof');
    end
    if ck == 1 | ck == 4 % end of chunk external
        len1=round(tim1-(pers(kper,2)/sds_.dt));
    end
end

[A,count]=fread(sds_.fid,[sds_.nch,len1],'float');
vec=-1;

if count ~= sds_.nch*len1
    sds_.eof=1;
    nread=count/sds_.nch;  % disp(nread)
    if nread > 0
        vec(1:nread)=A(chn,1:nread);
    end
    fclose(sds_.fid);
    if strcmp(sds_.filspost,'#NOFILE')
        sds_.eof=2;
        str=sprintf(' --------> End of files');
        disp(str);
        if noper == 0
            fprintf(fidlog,' End of files at %s ',datestr(now));
        end
    else
        sds_=sds_open([sds_.pnam sds_.filspost],pers);
        if sds_.eof == 3
            disp(['File ' sds_.file ' not opened']);
            str=sprintf(' --------> End of files');
            disp(str);
            return
        end
        str=sprintf(' *** open file %s',sds_.filme);
        disp(str);
        [A,count]=fread(sds_.fid,[sds_.nch,len-nread],'float');
        vec(nread+1:len)=A(chn,:);
    end
else
    vec=A(chn,:);
end

if noper == 0
    fclose(fidlog);
end
