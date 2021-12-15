function crea_sfdb1(sdsfile,chn,lfft,red)
%CREA_SFDB1  creates a short fft data base - old
%
%   sdsfile   first of concatenated files
%   lfft      length of (non-reduced) fft
%   red       reduction factor (normally 1, 4, 16, 64)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
    
if ~exist('sdsfile')
    snag_local_symbols;
    sdsfile=selfile(virgodata);
end

sds_=sds_open(sdsfile);
dt=sds_.dt;

if ~exist('chn')
    chn=sds_selch(sdsfile);
end

if ~exist('lfft')
    answ=inputdlg({'Length of (non-reduced) ffts ?','Reduction factor (norm. 1,4,16,64) ?'}, ...
        'Analysis parameters',1,{'4194304','1'});
    lfft=eval(answ{1});
    red=eval(answ{2});
end

len2=lfft/2;
len4=len2/2;
lenps=lfft/128;
lenps2=lenps/2;
ps=zeros(1,lenps2);
wind=ones(1,lfft);
for i = 1:len4
    wind(i)=1-cos(i*pi/len4);
    wind(lfft+1-i)=wind(i);
end

sbl_=sds_;
sbl_.nch=3;

ch(1).dx=0;
ch(1).dy=0;
ch(1).lenx=12;
ch(1).leny=1;
ch(1).type=6;
ch(1).name='detector velocities';

ch(2).dx=1/(dt*lenps);
ch(2).dy=0;
ch(2).lenx=lenps2;
ch(2).leny=1;
ch(2).type=4;
ch(2).name='reduced power spectrum';

ch(3).dx=1/(dt*lfft);
ch(3).dy=0;
ch(3).lenx=len2;
ch(3).leny=1;
ch(3).type=5;
ch(3).name='fft (half)';

sbl_.ch=ch;

sbl_=sbl_openw('sfdb.sbl',sbl_);
fid=sbl_.fid;
    
%sds_=sds_open(sdsfile);
t0=sds_.t0;
dt=sds_.dt;

[vv,sds_]=vec_from_sds(sds_,chn,len2);
nbl=0;
tbl=t0;
sbhead=[0 0];
par(1:12)=0;

while sds_.eof < 2
    for j = 1:64
        jj=(j-1)*lenps+1;
        jj1=jj+lenps-1; % disp([j jj jj1])
        p=abs(fft(vv(jj:jj1)));
        p=p(1:lenps2);
        ps=ps+p.*p;
    end
    [vec1,sds_]=vec_from_sds(sds_,chn,len2);
    if length(vec1) ~= len2
        break
    end
    vv(len2+1:lfft)=vec1;
    VV=fft(vv.*wind);
    nbl=nbl+1;
    sbl_headblw(fid,nbl,tbl);
    sbl_write(fid,sbhead,6,par);
    sbl_write(fid,sbhead,4,ps);
    sbl_write(fid,sbhead,5,VV(1:len2));
    vv(1:len2)=vv(len2+1:lfft);
    tbl=tbl+len2*dt;
end
    
fclose(fid);

fid=fopen(sbl_.file,'r+');
fseek(fid,24,'bof');
fwrite(fid,nbl,'int64');
fclose(fid);
