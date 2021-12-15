function crea_sfdb(sdsfile,chn,lfft,red,pers)
%CREA_SFDB  creates a short fft data base
%
%   sdsfile   first of concatenated files
%   lfft      length of (non-reduced) fft
%   red       reduction factor (normally 1, 4, 16, 64)
%   pers      observation periods (see sds_open)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
 
%-------------------------------------------
% Interactive part - NOT IN THE C CODE

if ~exist('sdsfile')
    snag_local_symbols;
    sdsfile=selfile(virgodata);
end

if ~exist('chn')
    chn=sds_selch(sdsfile);
end

if ~exist('lfft')
    answ=inputdlg({'Length of (non-reduced) ffts ?','Reduction factor (norm. 1,4,16,64) ?'}, ...
        'Analysis parameters',1,{'4194304','1'});
    lfft=eval(answ{1});
    red=eval(answ{2});
end

if ~exist('pers')
    pers=0;
end

%-------------------------------------------
% open sds input file

sds_=sds_open(sdsfile,pers);
t0=sds_.t0;
dt=sds_.dt;

%-------------------------------------------
% Parameter setting part

lentot=lfft*red;
lentot2=lentot/2;
len2=lfft/2;
len4=len2/2;
lenps=lfft/128;
lenps2=lenps/2;
nmin=60/dt;
omplen=floor(lfft/(2*nmin));

wind=ones(1,lfft);
for i = 1:len4
    wind(i)=1-cos(i*pi/len4);
    wind(lfft+1-i)=wind(i);
end

sbl_=crea_sblheader(sds_,lfft,red);

%-------------------------------------------
% open sbl output file

sbl_=sbl_openw('sfdb.sbl',sbl_);
fid=sbl_.fid;

%-------------------------------------------
% first sds read

ww=zeros(1,lentot);
vv=zeros(1,lfft);
[ww(len4*red+1:lentot),sds_]=vec_from_sds(sds_,chn,lentot-len4*red,pers); 

%-------------------------------------------
% sds reading loop

nbl=0;
tbl=t0;
sbhead=[0 0];
par(1:12)=0;
ps=zeros(1,lenps2);
omp=zeros(1,omplen);

while sds_.eof < 2
    par=comp_par(sds_); % computes velocities
    vv=reduce_data(ww,red); % from lentot to lfft
    vv=purge_data(vv);  % cancels big peaks
    ps=ps128(vv,ps);
    omp=oneminpow(vv,omp,nmin,omplen);
    
    VV=fft(vv.*wind);
    
    nbl=nbl+1;
    sbl_headblw(fid,nbl,tbl);
    sbl_write(fid,sbhead,6,par);
    sbl_write(fid,sbhead,4,ps);
    sbl_write(fid,sbhead,4,omp);
    sbl_write(fid,sbhead,5,VV(1:len2));
 %   vv(1:len2)=vv(len2+1:lfft);
    tbl=tbl+len2*dt;
    
    ww(1:lentot2)=ww(lentot2+1:lentot);
    [vec1,sds_]=vec_from_sds(sds_,chn,lentot2,pers);
    if length(vec1) ~= lentot2
        break
    end
    ww(lentot2+1:lentot)=vec1;
end
    
fclose(fid); % close sbl output file

%-------------------------------------------
% finalize sbl file

fid=fopen(sbl_.file,'r+');
fseek(fid,24,'bof');
fwrite(fid,nbl,'int64');
fclose(fid);


function sbl_=crea_sblheader(sds_,lfft,red)
%CREA_SBLHEADER

t0=sds_.t0;
dt=sds_.dt;
lenps=lfft/128;
nmin=60/dt;
omplen=floor(lfft/(2*nmin));

sbl_=sds_;
sbl_.nch=4;

ch(1).dx=0;
ch(1).dy=0;
ch(1).lenx=100;
ch(1).leny=1;
ch(1).type=6;
ch(1).name='detector parameters';

ch(2).dx=1/(dt*lenps);
ch(2).dy=0;
ch(2).lenx=lenps/2;
ch(2).leny=1;
ch(2).type=4;
ch(2).name='reduced power spectrum';

ch(3).dx=dt*lfft/(2*omplen);
ch(3).dy=0;
ch(3).lenx=omplen;
ch(3).leny=1;
ch(3).type=4;
ch(3).name='one minute power';

ch(4).dx=1/(dt*lfft);
ch(4).dy=0;
ch(4).lenx=lfft/2;
ch(4).leny=1;
ch(4).type=5;
ch(4).name='fft (half)';

sbl_.ch=ch;



function par=comp_par(sds_)
%COMP_PAR  computes the parameters for the blocks
%
%   dummy, per ora

par=1:100;



function vv=reduce_data(ww,red)
%REDUCE_DATA  reduces data for the different bands
%

if red > 1
    vv=aa_subsamp(ww,16384,16384/red);
else
    vv=ww;
end


function vv=purge_data(ww)
%PURGE_DATA   identifies and purge large event
%
%   DUMMY

vv=ww;


function ps=ps128(vv,ps)
%PS64  computes the shurt power spectrum
%
%    vv    input chunk
%
% works with big powers of 2 chunks

len=length(vv);
lenps=len/128;
lenps2=lenps/2;
ps=zeros(1,lenps2);

for j = 1:128
    jj=(j-1)*lenps+1;
    jj1=jj+lenps-1; % disp([j jj jj1])
    p=abs(fft(vv(jj:jj1)));
    p=p(1:lenps2);
    ps=ps+p.*p;
end

ps=ps/128;


function omp=oneminpow(vv,omp,nmin,ch3l)
%ONEMINPOW  about one minute power 
%
%   vv   input chunk

omp=zeros(1,ch3l);
j1=length(vv)/4;

for i = 1:ch3l
    omp(i)=mean(vv(j1+1:j1+nmin).^2);
    j1=j1+nmin;
end