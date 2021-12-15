function [recs]=check_sfdb(freq,folder,pialist)
%
%
%    [recs]=check_sfdb(freq,folder,pialist)
%
%   freq        frequency band [min max] ; n -> whole band, n is the number of blocks per file
%   folder      folder containing the input pia files
%   pialist     pia file list (obtained with dir /b/s > list.txt) 
%
%   iok         = 0 -> error
%   head        header of the output file
%
%  NOTES: 
%         in sbl_.dt there is the normal time between 2 ffts
%         attention at firstfrind

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

wholban=0;
noutblock=0;
if length(freq) == 1
    wholban=1;
    noutblock=freq;
end
fidlist=fopen([folder pialist]);
tline=fgetl(fidlist);
nfil=0;
while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

nbl=0;

for i = 1:nfil
    file=filepia{i};
    disp(file)
    fidpia=fopen([folder file]);

    if fidpia <= 0
        disp([file ' not opened'])
        piahead=0;data=0;
        return
    end

    iok=1;ftell(fidpia)
    [piahead,tps,sps,sft]=pia_read_block(fidpia);
    if ~isstruct(piahead)
        iok=0;
        disp(' *** ERROR !')
        return
    end

    inifr0=piahead.firstfrind*piahead.deltanu;
    finfr0=(piahead.nsamples-1)*piahead.deltanu+inifr0;
    if wholban == 1
        freq(1)=inifr0;
        freq(2)=finfr0;
    end
    k1=floor(freq(1)/piahead.deltanu)+1;
    fr1=(k1-1)*piahead.deltanu;% k1,freq(1),piahead.deltanu,fr1
    k2=round(freq(2)/piahead.deltanu)+1;
    fr2=(k2-1)*piahead.deltanu;
    frs1=max(fr1-10,inifr0);
    ks1=round(frs1/(piahead.deltanu*piahead.red));
    frs2=min(fr2+10,finfr0);
    ks2=round(frs2/(piahead.deltanu*piahead.red));
    sft=sft(k1:k2);
    
    tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
    mjd=gps2mjd(tbl);
    % sbhead=[piahead.firstfrind/piahead.tbase 0];
    sbhead2=[0 0];
    figure,hold on
    

    while piahead.eof == 0
        nbl=nbl+1;
        
        recs(nbl)=std(sft);plot(abs(sft),'color',rotcol(nbl)),drawnow,pause(1),ftell(fidpia)
        [piahead,tps,sps,sft]=pia_read_block_part(fidpia,k1,k2);%piahead
% [piahead,tps,sps,sft]=pia_read_block(fidpia);%piahead
% sft=sft(k1:k2);
        if piahead.eof == 0
            tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
            mjd=gps2mjd(tbl);
        end
    end

    fclose(fidpia);
end

nbl