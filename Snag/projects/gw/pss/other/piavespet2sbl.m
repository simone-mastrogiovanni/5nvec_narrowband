function iok=piavespet2sbl(pialist,filesbl)
%PIAVESPET2SBL  puts in a sbl files the sfdb average short spectra
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
        [piahead,avesps]=pia_read_block_09(fidpia);
    else
        [piahead,avesps]=pia_read_block(fidpia);
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
    ch(1).lenx=length(avesps);
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

    while piahead.eof == 0
        nbl=nbl+1;
        sbl_headblw(fid,nbl,mjd);
        sbl_write(fid,sbhead,4,avesps);
        
        if sfdb09 == 1
            [piahead,avesps]=pia_read_block_09(fidpia);
        else
            [piahead,avesps]=pia_read_block(fidpia);
        end
        
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
        