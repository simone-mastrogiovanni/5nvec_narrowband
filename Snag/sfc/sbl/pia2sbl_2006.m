function iok=pia2sbl(folder,filepia,filesbl)
%
%   folder      folder containing the input pia files
%   filepia     pia file
%   filesbl     file sbl to create
%
% The format is a reduced sfdb format

iok=1;
[piahead,data]=pia_read_2006([folder filepia]);
if ~isstruct(piahead)
    iok=0;
    disp(' *** ERROR !')
    return
end

len2=piahead.nsamples;
tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
sbhead=[piahead.firstfrind/piahead.tbase 0];

sbl_.nch=1;
sbl_.len=4; % ERRATO !
sbl_.capt=[' from ' filepia];
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

nbl=nbl+1
sbl_headblw(fid,nbl,tbl);
sbl_write(fid,sbhead,5,data);

fclose(fid);
        