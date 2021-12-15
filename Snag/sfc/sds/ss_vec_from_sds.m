function [vec,sds_]=ss_vec_from_sds(sds_,chn,len,ss,fftlen,pers)
%SS_VEC_FROM_SDS  fills vec with sub-sampled data from an sds file
%                   (similar to vec_from_sds)
% 
%  If the file ends, opens the following one.
%
%   sds_        sds structure
%   chn         number of the channel
%   len         length of subsampled data
%   ss          subsampling factor (typically a power of 2)
%   fftlen      length of the fft (must be divisible by 4*ss)
%   pers        observation periods (0 -> no; operating only at file level)

% Version 2.0 - March 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

outlen=fftlen/ss;
bufin=zeros(1,fftlen);
bufout=zeros(1,outlen);
vec=zeros(1,len);
iv=0;

sds_.acc=sds_.acc+1;
sds_.eof=0;

while iv < len & sds_.eof < 2
	[A,count]=fread(sds_.fid,[sds_.nch,fftlen],'float');
	bufin(1:count/sds_.nch)=A(chn,:);
	
	if count ~= sds_.nch*fftlen
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
            rest=fftlen-nread;
            [A,count]=fread(sds_.fid,[sds_.nch,rest],'float');
            bufin(nread+1:fftlen)=A(chn,:);
        end
	else
        bufout=aa_subsamp(A(chn,:),fftlen,outlen); %outlen,size(bufout),size(vec)
        vec(iv+1:iv+outlen)=bufout;
        iv=iv+outlen;
	end
end
