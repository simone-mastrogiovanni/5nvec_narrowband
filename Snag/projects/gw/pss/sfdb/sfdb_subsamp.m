function sfdb_subsamp(sdsfile,chn,lfft)
%SFDB_SUBSAMP  subsampling for sfdb
%
%   sdsfile   first of concatenated files
%   lfft      length of (non-reduced) fft

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
    answ=inputdlg({'Length of (non-reduced) ffts ?'}, ...
        'Analysis parameters',1,{'4194304');
    lfft=eval(answ{1});
    red=eval(answ{2});
end

len2=lfft/2;
len4=len2/2;
len8=len4/2;
len16=len8/2;
len32=len16/2;
len64=len32/2;
len128=len64/2;
wind=ones(1,lfft);
for i = 1:len4
    wind(i)=1-cos(i*pi/len4);
    wind(lfft+1-i)=wind(i);
end

sds4_=sds_;
sds4_.nch=1;
sds4_.ch='subsampled hrec';
sds4_.dt=sds_.dt*4;
sds4_.len=sds_.len/4;

sds16_=sds_;
sds16_.nch=1;
sds16_.ch='subsampled hrec';
sds16_.dt=sds_.dt*16;
sds16_.len=sds_.len/16;

sds64_=sds_;
sds64_.nch=1;
sds64_.ch='subsampled hrec';
sds64_.dt=sds_.dt*64;
sds64_.len=sds_.len/64;
    
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
