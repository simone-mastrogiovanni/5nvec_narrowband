function crea_ps(sdsfile,chn,lfft,red)
%CREA_SFDB  creates a short fft data base
%
%   sdsfile   first of concatenated files
%   lfft      length of the big fft
%   red       reduction factor for power spectrum

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('sdsfile')
    snag_local_symbols;
    sdsfile=selfile(virgodata);
end

if ~exist('chn')
    chn=sds_selch(sdsfile);
end

if ~exist('lfft')
    answ=inputdlg({'Length of big ffts ?','Power spectrum reduction factor ?'}, ...
        'Analysis parameters - input powers of 2',1,{'1048576','64'});
    lfft=eval(answ{1});
    red=eval(answ{2});
end

%-------------------------------------------
% open sds input file

sds_=sds_open(sdsfile);
t0=sds_.t0;
dt=sds_.dt;

%-------------------------------------------
% Parameter setting part

lentot=lfft;
lentot2=lentot/2;
len2=lfft/2;
len4=len2/2;
lenps=2*round(lfft/(2*red));
lenps2=lenps/2;
nmin=60/dt;
omplen=floor(lfft/(2*nmin));

wind=ones(1,lfft);
for i = 1:len4
    wind(i)=1-cos(i*pi/len4);
    wind(lfft+1-i)=wind(i);
end

sbl_=crea_sblheader(sds_,lenps);

%-------------------------------------------
% open ps output file

sbl_=sbl_openw('ps.sbl',sbl_);
fid=sbl_.fid;

%-------------------------------------------
% first sds read

ww=zeros(1,lentot);
vv=zeros(1,lfft);
[ww(len4+1:lentot),sds_]=vec_from_sds(sds_,chn,lentot-len4); 

%-------------------------------------------
% sds reading loop

nbl=0;
tbl=t0;
sbhead=[0 0];
par(1:12)=0;
ps=zeros(1,lenps2);
omp=zeros(1,omplen);

while sds_.eof < 2
    ps=psred(ww,ps,red);  % plot(ww),pause(1)
    
    VV=fft(ww.*wind);
    
    nbl=nbl+1;
    sbl_headblw(fid,nbl,tbl);
    sbl_write(fid,sbhead,4,ps);
 %   vv(1:len2)=vv(len2+1:lfft);
    tbl=tbl+len2*dt;
    
    ww(1:lentot2)=ww(lentot2+1:lentot);
    [vec1,sds_]=vec_from_sds(sds_,chn,lentot2);
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


function sbl_=crea_sblheader(sds_,lenps)
%CREA_SBLHEADER

t0=sds_.t0;
dt=sds_.dt;
nmin=60/dt;

sbl_=sds_;
sbl_.nch=1;

ch(1).dx=1/(dt*lenps);
ch(1).dy=0;
ch(1).lenx=lenps/2;
ch(1).leny=1;
ch(1).type=4;
ch(1).name='reduced power spectrum';

sbl_.ch=ch;



function ps=psred(vv,ps,red)
%PS64  computes the shurt power spectrum
%
%    vv    input chunk
%
% works with big powers of 2 chunks

len=length(vv);
lenps=len/red;
lenps2=lenps/2;
ps=zeros(1,lenps2);

for j = 1:red
    jj=(j-1)*lenps+1;
    jj1=jj+lenps-1; % disp([j jj jj1])
    p=abs(fft(vv(jj:jj1)));
    p=p(1:lenps2);
    ps=ps+p.*p;
end

ps=ps/red;
