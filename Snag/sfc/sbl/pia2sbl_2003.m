function pia2sbl(folder,filelist,filesbl)
%
%   folder      folder containing the input pia files
%   filelist    pia files list file
%   filesbl     file sbl to create
%
% The format is a reduced sfdb format

fidlist=fopen(filelist,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});
    disp(str);
end
fclose(fidlist);

for kfil = 1:nfiles
    [piahead,data]=pia_read([folder file{kfil}]);
    len2=piahead.nsamples;
    tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
    sbhead=[piahead.firstfrind/piahead.tbase 0];
    if kfil == 1
        sbl_.nch=1;
        sbl_.len=nfiles;
        sbl_.capt='Dati ROG';
        ch(1).dx=1/piahead.tbase;
        ch(1).dy=0;
        ch(1).lenx=len2;
        ch(1).leny=1;
        ch(1).type=5;
        ch(1).name='fft (half)';
        sbl_.ch=ch;
        sbl_.t0=tbl;
        sbl_.dt=piahead.tbase/(2*len2);
        
        sbl_=sbl_openw(filesbl,sbl_);
        fid=sbl_.fid;
        nbl=0;
    end
    
    nbl=nbl+1
    sbl_headblw(fid,nbl,tbl);
    sbl_write(fid,sbhead,5,data);
end

fclose(fid);
        