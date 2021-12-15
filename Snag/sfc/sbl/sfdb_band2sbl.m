function [iok sbl_]=sfdb_band2sbl(freq,cont,folder,pialist,filesbl)
%SFDB_BAND2SBL  puts in a sbl files a band of sfdb
%     the output file is single, except in the case of whole band
%
%    [iok head]=sfdb_band2sbl(freq,cont,folder,pialist,filesbl)
%
%   freq        frequency band [min max] ; n -> whole band, n is the number of blocks per file
%   cont        output file content: 1 -> only data 
%                                    2 -> data and velocity (double)
%                                    3 -> data, velocity (double) and short spectrum band
%   folder      folder containing the input pia files
%   pialist     pia file list (obtained with dir /b/s > list.txt) 
%   filesbl     file sbl to create
%
%   iok         = 0 -> error
%   head        header of the output file
%
%  NOTES: 
%         in sbl_.dt there is the normal time between 2 ffts
%         attention at firstfrind

% Version 2.0 - December 2007
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

    iok=1;
    [piahead,tps,sps,sft]=pia_read_block(fidpia);%piahead,semilogy(sps),length(tps),length(sps),length(a),ftell(fidpia)
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
    
    if i == 1
        sbl_.nch=cont;
        sbl_.len=0; 
        sbl_.capt=['band from sfdb files'];
        % ch(1).dx=1/piahead.tbase;
        switch cont
            case 1
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';
                
                sbhead1=[fr1 0];
            case 2
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';

                ch(2).dx=0;
                ch(2).dy=0;
                ch(2).lenx=3;
                ch(2).leny=1;
                ch(2).inix=0;
                ch(2).iniy=0;
                ch(2).type=6;
                ch(2).name='detector velocity';
                
                sbhead1=[fr1 0];
            case 3
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';

                ch(2).dx=0;
                ch(2).dy=0;
                ch(2).lenx=3;
                ch(2).leny=1;
                ch(2).inix=0;
                ch(2).iniy=0;
                ch(2).type=6;
                ch(2).name='detector velocity';

                ch(3).dx=piahead.deltanu*piahead.red;
                ch(3).dy=0;
                ch(3).lenx=ks2-ks1+1;
                ch(3).leny=1;
                ch(3).inix=frs1;
                ch(3).iniy=0;
                ch(3).type=4;
                ch(3).name='short power spectrum';
                
                
                sbhead1=[fr1 0];   
                sbhead3=[frs1 0];
        end

        sbl_.ch=ch;
        sbl_.t0=mjd;
        sbl_.dt=piahead.tbase;
        if piahead.typ == 2
            sbl_.dt=sbl_.dt/2;
        end

        sbl_=sbl_openw(filesbl,sbl_);
        
        fid=sbl_.fid;
    end

    while piahead.eof == 0
        nbl=nbl+1;
        sbl_headblw(fid,nbl,mjd);
        
        switch cont
            case 1
                sbl_write(fid,sbhead1,5,sft);
            case 2
                sbl_write(fid,sbhead1,5,sft);
                sbl_write(fid,sbhead1,6,[piahead.vx_eq piahead.vy_eq piahead.vz_eq]);
            case 3
                sbl_write(fid,sbhead1,5,sft);
                sbl_write(fid,sbhead1,6,[piahead.vx_eq piahead.vy_eq piahead.vz_eq]);
                sbl_write(fid,sbhead1,4,sps(ks1:ks2));
        end
        [piahead,tps,sps,sft]=pia_read_block_part(fidpia,k1,k2);%piahead
        if piahead.eof == 0
            tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
            mjd=gps2mjd(tbl);
        end
    end

    fclose(fidpia);
end

nbl
fseek(fid,24,'bof');
fwrite(fid,nbl,'uint32');
fclose(fid);
        