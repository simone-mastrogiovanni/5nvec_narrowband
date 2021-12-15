function [iok tt]=piaspet2sbl(pialist,filesbl)
%PIASPET2SBL  puts in a sbl files the sfdb short spectra
%
%   pialist     pia file list (obtained with dir /b/s > list.txt in the parent dir)
%   filesbl     file sbl to create
%

iok=0;
fidlist=fopen(pialist);
tline=fgetl(fidlist);
nfil=0;
while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

nbl=0;

for i = 1:nfil
    sfdb09=0;
    file=filepia{i};
    if file(1) == '!'
        fprintf('%s excluded \n',file)
        continue
    end
    disp(file)
    fidpia=fopen(file);

    if fidpia <= 0
        disp([file ' not opened'])
        piahead=0;data=0;
        return
    end
    
    [pathstr, name, ext] = fileparts(file);
    if lower(ext) == '.sfdb09' 
        sfdb09=1;
    end

    iok=1;
    if sfdb09 == 1
        [piahead,tps,sps]=pia_read_block_09(fidpia);
    else
        [piahead,tps,sps]=pia_read_block(fidpia);%piahead,semilogy(sps),length(tps),length(sps),length(a),ftell(fidpia)
    end
    
    if ~isstruct(piahead)
        iok=0;
        disp(' *** ERROR !')
        return
    end

    tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
    mjd=gps2mjd(tbl);
    % sbhead=[piahead.firstfrind/piahead.tbase 0];
    sbhead=[0 0];

    sbl_.nch=1;
    sbl_.len=4; % ERRATO !
    sbl_.capt=['spec from sfdb files'];
    % ch(1).dx=1/piahead.tbase;
    ch(1).dx=piahead.deltanu*piahead.red;
    ch(1).dy=0;
    lenx=length(sps);
    ch(1).lenx=lenx;
    ch(1).leny=1;
    ch(1).inix=0;
    ch(1).iniy=0;
    ch(1).type=4;
    ch(1).name='periodogram';
    sbl_.ch=ch;
    sbl_.t0=mjd;
    sbl_.dt=piahead.tbase;
    if piahead.typ == 2
        sbl_.dt=sbl_.dt/2;
    end

    if i == 1
        sbl_=sbl_openw(filesbl,sbl_);
    end
    fid=sbl_.fid;
    mjd0=0;

    while piahead.eof == 0
        nbl=nbl+1;
        sbl_headblw(fid,nbl,mjd);
        if length(sps) ~= lenx
            lenx0=length(sps);
            fprintf('Error ! lenx = %d  instead of %d \n',lenx0,lenx)
            if lenx0 < lenx
                sps(lenx0+1:lenx)=0;
            else
                sps=sps(1:lenx);
            end
        end
        sbl_write(fid,sbhead,4,sps);
        
        if sfdb09 == 1
            [piahead,tps,sps]=pia_read_block_09(fidpia);
        else
            [piahead,tps,sps]=pia_read_block(fidpia);
        end
        
        if piahead.eof == 0
            tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
            mjd=gps2mjd(tbl);
            if mjd < mjd0
                disp('ERROR !!!')
                piahead
            end
        end
        mjd0=mjd;
        tt(nbl)=mjd;
    end

    fclose(fidpia);
end

nbl
fseek(fid,24,'bof');
fwrite(fid,nbl,'uint32');
fclose(fid);
        