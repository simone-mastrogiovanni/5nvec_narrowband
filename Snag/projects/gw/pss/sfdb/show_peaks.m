function [x,y,z,tim1,inifr,dfr,i,j]=show_peaks(frband,thr,time,file)
%SHOW_PEAKS  show peaks of a peakmap in a vbl file
%             updated to support v09 format
%
%   [x,y,z,tim1,inifr,dfr,i,j]=show_peaks(frband,thr,time,file)
%
%   frband      [min,max] frequency; =0 all
%   thr         [min,max] threshold; =0 all
%   time        [min,max] time (mjd); =0 all
%   file        input file 
%
%   x,y,z       peaks data (time,frequency,amplitude)
%   tim1        times of the spectra
%   inifr,dfr   frequency parameters
%   i,j         peaks indices

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


if ~exist('file','var')
    file=selfile('  ','Choose vbl peakmap file');
end

if frband == 0
    frband=[0 1000000];
end
if thr == 0
    thr=[0 1e100];
end
if time == 0
    time=[0 1000000];
end

vbl_=vbl_open(file);

if vbl_.nch == 3
    disp('Type 1 peakmap file')
    ich=2;
elseif vbl_.nch == 5
    disp('Type 2 peakmap file')
    ich=4;
    ictyp=2;
else
    disp('*** Attention ! strange vbl file')
end

dfr=vbl_.ch(ich).dx;
lfft=vbl_.ch(ich).lenx*2;
inifr=vbl_.ch(ich).inix;
if dfr == 0
    disp('*** errors in fft parameters; default set')
    lfft=4194304
    dfr=4000/lfft
    inifr=0;
end

binmin=floor(frband(1)/dfr);
binmax=ceil(frband(2)/dfr);

nbin=binmax-binmin+1;
if nbin > lfft/2
    nbin=lfft/2;
end

frin=inifr*dfr;

vbl_.nextblock=0;
len=vbl_.len;
if len == 0
    disp('*** No length - cut at 1000')
    len=1000;
end

nbin,len

kbl=0;
x=[];
y=x;
z=x;
i=x;
j=x;

while vbl_.eof == 0
    kbl=kbl+1;
    if kbl > len
        break
    end
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        break
    end
    if floor(kbl/10)*10 == kbl
        disp(kbl)
    end

    kch=vbl_.block;
    tim=vbl_.bltime;
    tim1(kbl)=tim;
    
    if tim > time(1) & tim < time(2)
        vbl_=vbl_headchr(vbl_);
        vel=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); % p09
        if ictyp == 2
            vbl_=vbl_nextch(vbl_);
            lensp=vbl_.ch0.lenx;
            inisp=vbl_.ch0.inix;
            dfsp=vbl_.ch0.dx;
            sp=fread(vbl_.fid,lensp,'float32');
            vbl_=vbl_nextch(vbl_);
        end
        vbl_=vbl_nextch(vbl_);
        npeak=vbl_.ch0.lenx;
        bin=fread(vbl_.fid,npeak,'int32');
        vbl_=vbl_nextch(vbl_);
        amp=fread(vbl_.fid,npeak,'float32');
        ibin=find(bin>=binmin&bin<=binmax);
        if length(ibin) < 1
            continue
        end
        ibmin=ibin(1);
        ibmax=ibin(length(ibin));
        bin=bin(ibmin:ibmax);
        amp=amp(ibmin:ibmax);
        ibin=find(amp>=thr(1)&amp<=thr(2));
        bin=bin(ibin);
        amp=amp(ibin);
        x=[x bin'*0+tim];
        y=[y bin'];
        z=[z amp'];
        i=[i bin'*0+kbl];
        j=[j bin'];
%         vsp=sparse(bin-binmin+1,1,amp,nbin,1);
%         spfr=spfr+vsp;
%         peakfr=peakfr+sign(vsp);
%         sptim(kbl)=mean(vsp);
%         peaktim(kbl)=sum(sign(vsp));
    end
end

y=y*dfr+inifr;
x=x-floor(x(1));

plot_triplets(x,y,log10(z)),grid on