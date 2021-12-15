function sds2sfdb09(file,lfft,filehead)
% SDS2SFDB09  creates an sfdb09 file 
%    LIMITATION: fake Doppler
%
%     g=sds2sfdb09(file,t,band,dt,filehead)
%
%   file      the first sds file or list (or 0 -> interactive choice)
%             the list is used in case of more decades. It is created by 
%                 dir /b/s  > list.txt
%             and then edited taking only the first file of the each decade, as
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090707\VIR_V1_h_4096Hz_20090707_131945_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090717\VIR_V1_h_4096Hz_20090717_010625_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090728\VIR_V1_h_4096Hz_20090728_002625_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090807\VIR_V1_h_4096Hz_20090807_002625_.sds
% 
%   lfft      FFT length
%   filehead  head of the name of the files (in absence a default name)
%             if filehead is a double, it is the frequency of a simulation;
%             the filehead is 'sinsim'
%
% piahead.endian=fread(fid,1,'double');
% piahead.detector=fread(fid,1,'int32');    % detector (0,1)
% piahead.gps_sec=fread(fid,1,'int32');     
% piahead.gps_nsec=fread(fid,1,'int32');    
% piahead.tbase=fread(fid,1,'double');      % length of fft in s
% piahead.firstfrind=fread(fid,1,'int32');  %
% piahead.nsamples=fread(fid,1,'int32');    % number of samples of fft 
% 
% piahead.red=fread(fid,1,'int32');         % reduction factor (very short spectrum)
% piahead.typ=fread(fid,1,'int32');         % 
% piahead.n_flag=fread(fid,1,'float32');      
% piahead.einstein=fread(fid,1,'float32');  %
% piahead.mjdtime=fread(fid,1,'double');
% piahead.nfft=fread(fid,1,'int32');
% piahead.wink=fread(fid,1,'int32');        %
% piahead.normd=fread(fid,1,'float32');       % factor |fft|^2 -> pow spect
% piahead.normw=fread(fid,1,'float32');       % factor window (to be multiplied for normd)
% piahead.frinit=fread(fid,1,'double');     %
% piahead.tsamplu=fread(fid,1,'double');    % original sampling time
% piahead.deltanu=fread(fid,1,'double');    % fft frequency bin
% 
% piahead.vx_eq=fread(fid,1,'double'); 
% piahead.vy_eq=fread(fid,1,'double'); 
% piahead.vz_eq=fread(fid,1,'double'); 
% piahead.px_eq=fread(fid,1,'double'); 
% piahead.py_eq=fread(fid,1,'double'); 
% piahead.pz_eq=fread(fid,1,'double');
% piahead.n_zeroes=fread(fid,1,'int32');
% piahead.sat_howmany=fread(fid,1,'double');
% piahead.spare1=fread(fid,1,'double');
% piahead.spare2=fread(fid,1,'double');
% piahead.spare3=fread(fid,1,'double');
% piahead.spare4=fread(fid,1,'float32');
% piahead.spare5=fread(fid,1,'float32');
% piahead.spare6=fread(fid,1,'float32');
% piahead.lavesp=fread(fid,1,'int32');
% piahead.spare8=fread(fid,1,'int32');
% piahead.spare9=fread(fid,1,'int32');

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

NSFT=100;

if isnumeric(file)
    file=selfile(' ');
end

if ~exist('filehead','var')
    filehead='h';
end

icsim=0;
if isnumeric(filehead)
    frsim=filehead;
    isim=0;
    icsim=1;
    filehead='sinsim';
end

[pathstr,name,ext]=fileparts(file);

iclist=0;
ndeca=1;
if ~strcmp(ext,'.sds')
    disp('  Decade List Mode')
    iclist=1;
    fidlist=fopen(file);
    tline=fgetl(fidlist);
    ndeca=0;

    while tline ~= -1
        ndeca=ndeca+1;
        filelist{ndeca}=tline;
        tline=fgetl(fidlist);
    end
    file=filelist{1};
end

file
sds_=sds_open(file);
str=sprintf(' *** open file %s',file);
disp(str);

t0=sds_.t0;
dt=sds_.dt;
len=sds_.len;

n2=lfft/2;
n4=lfft/4;
n3=n4*3;
t1=t0;
dfr=1/(lfft*dt);
x=zeros(lfft,1);
npiec=0;

piahead.endian=1;
piahead.detector=1;      % detector (0,1)
piahead.gps_sec=0;     
piahead.gps_nsec=0;    
piahead.tbase=lfft*dt;   % length of fft in s
piahead.firstfrind=0;    %
piahead.nsamples=lfft/2; % number of samples of fft 

piahead.red=128;         % reduction factor (very short spectrum)
piahead.typ=2;           % 
piahead.n_flag=0;      
piahead.einstein=10^-20; %
piahead.mjdtime=0;
piahead.nfft=NSFT;
piahead.wink=0;        %
piahead.normd=0;       % factor |fft|^2 -> pow spect
piahead.normw=0;       % factor window (to be multiplied for normd)
piahead.frinit=0;      %
piahead.tsamplu=dt;    % original sampling time
piahead.deltanu=dfr;   % fft frequency bin

piahead.vx_eq=0; 
piahead.vy_eq=0; 
piahead.vz_eq=0; 
piahead.px_eq=0; 
piahead.py_eq=0; 
piahead.pz_eq=0;
piahead.n_zeroes=0;
piahead.sat_howmany=0;
piahead.spare1=0;
piahead.spare2=0;
piahead.spare3=0;
piahead.spare4=0;
piahead.spare5=0;
piahead.spare6=0;
% piahead.spare7=0; used by piahead.lavesp
piahead.spare8=0;
piahead.spare9=0;

for kdeca = 1:ndeca
    [x(n3+1:lfft) tim0 cont sds_]=read_sds_vec(sds_,n4,t1);
    T1=tim0-n3*dt/86400;
    if icsim == 1
        [sim isim]=simsin(frsim,dt,n4,isim);
        x(n3+1:lfft)=sim;
    end
    nn=n4;
    npiec=npiec+1;
    ksft=0;

    while 1
        x(1:n2)=x(n2+1:lfft);
        t2=t1+nn*dt/86400;
        [x(n2+1:lfft) t1 cont sds_]=read_sds_vec(sds_,n2,t2); 
        T1=t1-n2*dt/86400;
        npiec=npiec+1;
        if sds_.eof >= 2
            break
        end
        if icsim == 1
            [sim isim]=simsin(frsim,dt,n2,isim);
            x(n2+1:lfft)=sim;
        end
        nn=n2;
        if cont == 1
            hole=(t1-t2)*86400/dt; % in output units
            ihole=ceil(hole);
            idel=round((ihole-hole)*rdt);
            fwrite('Hole of %f s at piece %d on %s; %d input samples deleted\n',hole*dt,npiec,mjd2s(t1),idel)
            x(1:n4)=0;
            x(n4+1-idel:n4+n2-idel)=x(n2+1:lfft);
            nrest=n2-n4+idel;
            t2=t1+nn*dt/86400;
            [x(n4+n2-idel+1:lfft) t1 , cont, sds_]=read_sds_vec(sds_,nrest,t2);
            T1=t1-(n4+n2-idel)*dt/86400;
            if icsim == 1
                isim=isim+round(ihole*rdt);
                [sim isim]=simsin(frsim,dt,nrest,isim);
                x(n4+n2-idel+1:lfft)=sim;
            end
            nn=nrest;
        end

        if floor(ksft/NSFT)*NSFT == ksft
            if exist('fidout','var')
                fclose(fidout);
            end
            fidout=openw_sfdb09(filehead,T1,ksft+1);
        end
        
        xf=fft(x);
        ksft=ksft+1;
        piahead.mjdtime=T1;
        gps=mjd2gps(T1);
        piahead.gps_sec=floor(gps);     
        piahead.gps_nsec=(gps-floor(gps))*10^9;    
        sfdb09_write_block(fidout,piahead,xf)
    end
    if kdeca < ndeca
        file=filelist{kdeca+1};
        sds_=sds_open(file);
        str=sprintf(' *** open file %s',file);
        disp(str);
    end
end


function [sim isim]=simsin(fr,dt,n,isim)

phi=2*pi*mod((isim+(0:n-1))*fr*dt,1);
sim=sin(phi);
isim=isim+n;


function fid=openw_sfdb09(filehead,mjd,ksft)

s=mjd2_d_t(mjd);
s1=num2str(ksft);
file=[filehead s s1 '.sfdb09'];
fid=fopen(file,'w');
fprintf(' -> sfdb0 file %s \n',file)


function sfdb09_write_block(fid,piahead,sft)

fwrite(fid,piahead.endian,'double');
fwrite(fid,piahead.detector,'int32');
fwrite(fid,piahead.gps_sec,'int32');
fwrite(fid,piahead.gps_nsec,'int32');
fwrite(fid,piahead.tbase,'double');
fwrite(fid,piahead.firstfrind,'int32');
fwrite(fid,piahead.nsamples,'int32');
fwrite(fid,piahead.red,'int32');
fwrite(fid,piahead.typ,'int32');
fwrite(fid,piahead.n_flag,'float32');
fwrite(fid,piahead.einstein,'float32');
fwrite(fid,piahead.mjdtime,'double');
fwrite(fid,piahead.nfft,'int32');
fwrite(fid,piahead.wink,'int32');
fwrite(fid,piahead.normd,'float32');
fwrite(fid,piahead.normw,'float32');
fwrite(fid,piahead.frinit,'double');
fwrite(fid,piahead.tsamplu,'double');
fwrite(fid,piahead.deltanu,'double');
fwrite(fid,piahead.vx_eq,'double');
fwrite(fid,piahead.vy_eq,'double');
fwrite(fid,piahead.vz_eq,'double');
fwrite(fid,piahead.px_eq,'double');
fwrite(fid,piahead.py_eq,'double');
fwrite(fid,piahead.pz_eq,'double');
fwrite(fid,piahead.n_zeroes,'int32');
fwrite(fid,piahead.sat_howmany,'double');
fwrite(fid,piahead.spare1,'double');
fwrite(fid,piahead.spare2,'double');
fwrite(fid,piahead.spare3,'double');
fwrite(fid,piahead.spare4,'float32');
fwrite(fid,piahead.spare5,'float32');
fwrite(fid,piahead.spare6,'float32');
fwrite(fid,piahead.lavesp,'int32');
fwrite(fid,piahead.spare8,'int32');
fwrite(fid,piahead.spare9,'int32');

ltps=piahead.red;
tps=1:ltps;
fwrite(fid,tps,'float');
lsps=piahead.nsamples/ltps;
sps=1:lsps;
fwrite(fid,sps,'float');
n=piahead.nsamples;
n2=2*n;
cdat(1:2:n2)=real(sft(1:n));
cdat(2:2:n2)=imag(sft(1:n));
fwrite(fid,cdat,'float');