function datout=check_sfdb09(folder,pialist)
%CHECK_SFDB09  analyze sfdb09 files in decades
%
%    datout=check_sfdb09(folder,pialist)
%
%   folder      folder containing the input pia files
%   pialist     pia file list (obtained with dir /b/s > list.txt in the parent dir) 

% Version 2.0 - April 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome 

datout=0;
format long

fidlist=fopen([folder pialist]);
tline=fgetl(fidlist);
nfil=0;

tstr=snag_timestr(now);
fidlog=fopen(['check_sfdb09_' tstr '.log'],'w');
fprintf(fidlog,'Operating on file list %s at %s \n\n',[folder pialist],tstr);

dt0all=[];
phall=[];

while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

k1=1;
k2=2;
nbl=1;

for i = 1:nfil
    file=filepia{i};
    disp(file)
    fidpia=fopen(file);

    if fidpia <= 0
        disp([file ' not opened'])
        piahead=0;data=0;
        return
    end

    iok=1;
    [piahead,tps,sps,sft]=pia_read_block_09(fidpia);
    if ~isstruct(piahead)
        iok=0;
        disp(' *** ERROR !')
        return
    end
   
    mjd=piahead.mjdtime;
    disp(mjd2s(mjd))
    dtori=piahead.tsamplu;
    lfftori=piahead.nsamples*2;
    
    datout(nbl,1)=i;
    datout(nbl,2)=mjd;
    
    if i == 1
        dfr=piahead.deltanu;
        dtfft=piahead.tbase/2;
        mjd1=piahead.mjdtime-dtfft/86400;disp('Set of mjd1');
        fprintf(fidlog,'   Original parameters: dt,lfft,dfr,dtfft  %f, %d, %f %f \n',dtori,lfftori,dfr,dtfft);
    end

    while piahead.eof == 0
        nbl=nbl+1;

        hole=((mjd-mjd1)*86400-dtfft);
        mjd1=mjd;
        ihole=round(hole);
        if abs(hole-ihole) > 1.e-6
            fprintf(' *** ATTENTION ! gap of %f \n',hole-ihole);
            fprintf(fidlog,' *** ATTENTION ! gap of %f \n',hole-ihole);
        end
        if ihole > 0
            fprintf(' Hole of %f s\n',hole);
            fprintf(fidlog,' Hole of %f s\n',hole);
        end 
        
        piahead=pia_read_block_part_09(fidpia,k1,k2);%piahead
        if piahead.eof == 0
            mjd=piahead.mjdtime;
%             disp(mjd2s(mjd))
        end
%         sft=sft*FACT1ONSQRT2;
        datout(nbl,1)=i;
        datout(nbl,2)=mjd;
    end

    fclose(fidpia);
end

nbl

fclose(fidlog);