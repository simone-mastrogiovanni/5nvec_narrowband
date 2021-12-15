function [vec,sds_,tim0,holes]=vec_from_sds_allch(sds_,len,alpers)
%VEC_FROM_SDS_ALLCH  fills vec with data from sds files (all channels)
% 
%    Rules:
%
%  - If the file ends, opens the following one
%  - In case of holes, fills with zeros
%  - Vectors doesn't starts in holes, but with the beginning of next file
%  - If "alpers" (Allowed Periods) is operative (present), non-allowed
%    periods are zeroed. All-zeroes vectors are jumped
%
%   sds_        sds structure
%   len         length (for each channel)
%   alpers      (n,2) array containing the start and stop time of the n allowed periods
%               It is omitted or 0 if there are no selection periods. 
%
%   vec         the data (in one vect, for all channels)
%   tim0        first sample time (in mjd)
%   holes       structure describing holes
%     .nztot      total number of inserted zeros
%     .nzeros     number of inserted zeros (for each hole - possibly an array)
%     .kzeros     vec index that starts the zeros (possibly an array)
%     .end        =1 end of continuous chunk

% Version 2.0 - July 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

persel=0;
if exist('alpers')
    if length(alpers) > 1
        persel=1;
    end
else
    alpers=0;
end

sds_.acc=sds_.acc+1;
sds_.eof=0;
holes.nztot=0;holes.nzeros=0;holes.kzeros=0;holes.nholes=0;holes.end=0;
tim0=0;
vec=-1;
kskipped=0;

if sds_.fid < 0
    disp('End files or error');
    return
end

pos=ftell(sds_.fid);
ndat=(pos-sds_.point0)/(sds_.nch*4);
tim0=sds_.t0+sds_.dt*ndat/86400; 
timend_exp=tim0+len*sds_.dt/86400;


len2=0;
len1=len-len2;
kvec=1;

while len1 > 0
    [A,count]=fread(sds_.fid,sds_.nch*len1,'float');
    nread=count/sds_.nch;  % disp(nread)
    len2=len2+nread;
    len1=len-len2;
    
    if nread > 0
        vec(kvec:len2*sds_.nch)=A;
        kvec=(len2+1)*sds_.nch;
    end

    if len1 > 0
        sds_.eof=1;
        fclose(sds_.fid);
        if strcmp(sds_.filspost,'#NOFILE')
            sds_.eof=2;
            str=sprintf(' --------> End of concatenated files');
            disp(str);
            vec(kvec:len*sds_.nch)=0;
            len2=len;
            len1=0;
            holes.nholes=holes.nholes+1;
            holes.nzeros(holes.nholes)=len-kvec/sds_.nch+1;
            holes.nztot=holes.nztot+holes.nzeros(holes.nholes);
            holes.kzeros(holes.nholes)=kvec/sds_.nch;
            holes.end=1;
            
            return
        else
            sds_=sds_open([sds_.pnam sds_.filspost],alpers);
            if sds_.eof == 3
                disp(['File ' sds_.file ' not opened']);
                str=sprintf(' --------> End of files');
                disp(str);
                
                vec(kvec:len*sds_.nch)=0;
                len2=len;
                len1=0;
                holes.nholes=holes.nholes+1;
                holes.nzeros(holes.nholes)=len-kvec/sds_.nch+1;
                holes.nztot=holes.nztot+holes.nzeros(holes.nholes);
                holes.kzeros(holes.nholes)=kvec/sds_.nch;
                holes.end=1;
                
                return
            end
            str=sprintf(' *** open file %s',sds_.filme);
            disp(str);
            tim=sds_.t0;
            hole=round((tim-tim0)*86400/sds_.dt-len2);%(tim-tim0)*86400,hole
            if hole > len1    
                vec(kvec:len*sds_.nch)=0;
                len1=0;
                len2=len;
                holes.nholes=holes.nholes+1;
                holes.nzeros(holes.nholes)=len-kvec/sds_.nch+1;
                holes.nztot=holes.nztot+holes.nzeros(holes.nholes);
                holes.kzeros(holes.nholes)=kvec/sds_.nch;
                holes.end=1;
            else 
                if hole > 0    
                    vec(kvec*sds_.nch:(kvec+hole)*sds_.nch-1)=0;
                    len2=len2+hole;
                    len1=len-len2;
                    holes.nholes=holes.nholes+1;
                    holes.nzeros(holes.nholes)=hole;
                    holes.nztot=holes.nztot+holes.nzeros(holes.nholes);
                    holes.kzeros(holes.nholes)=kvec/sds_.nch;
                    kvec=len2*sds_.nch+1; ! attenzione
                end
            end
        end
    end
    
    if len1 <= 0
        if persel == 1
            vec=zero_pers(vec,tim0,sds_.dt,alpers);
            if max(abs(vec)) == 0
                kskipped=kskipped+1;
                str1=sprintf(' %d vecs skipped',kskipped);
                disp(str1);
                holes.nholes=0;
                len2=0;
                len1=len-len2;
                kvec=1;
                tim0=timend_exp; 
                timend_exp=tim0+len*sds_.dt/86400;
            end
        end
    end
end

% plot(vec),nztot
