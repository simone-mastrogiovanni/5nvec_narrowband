function [A tim vel vbl_]=read_peakmap(frband,thr,time,file)
%READ_PEAKMAP  reads a vbl-file peakmap
%                 updated to support v09 format
%
% In a vbl-file, type 1, the first channel is the velocity, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
% In a vbl-file, type 2, the first channel is the velocity, the second the short spectrum,
% the third the index to the peakbin (for direct access), the fourth the frequency bins 
% (the peakbin), the fifth the CR.
%
%   frband    [min,max] frequency; =0 all
%   thr       [min,max] threshold (mjd); =0 all
%   time      [min,max] time (mjd); =0 all
%   file      input file
%
%   A         output (a gd2 sparse, with velocities)

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('file')
    file=selfile('  ');
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

ictyp=1;

if vbl_.nch == 3
    disp('Type 1 peakmap file')
    ich=2;
    dfr=vbl_.ch(ich).dx;
    lfft=vbl_.ch(ich).lenx*2;
    if dfr == 0
        disp('*** errors in fft parameters; default set')
        lfft=4194304
        dfr=4000/lfft
    end
elseif vbl_.nch == 5
    disp('Type 2 peakmap file')
    ich=4;
    dfr=vbl_.ch(ich).dx;
    lfft=vbl_.ch(ich).lenx*2;
    ictyp=2;
elseif vbl_.nch == 6
    disp('Type 3 peakmap file')
    ich=4;
    dfr=vbl_.ch(ich).dx;
    lfft=vbl_.ch(ich).lenx*2;
    ictyp=3;
else
    disp('*** Attention ! strange vbl file')
end

binmin=floor(frband(1)/dfr);
binmax=ceil(frband(2)/dfr);

nbin=binmax-binmin+1;
if nbin > lfft/2
    nbin=lfft/2;
end

vbl_.nextblock=0;
len=vbl_.len;
if len == 0
    disp('*** No length - cut at 1000')
    len=1000;
end
vel=zeros(len,6);
tim(1:len)=0;
A=sparse(nbin,len); nbin,len
kbl=0;

while vbl_.eof == 0
    kbl=kbl+1;
    if kbl > len
        break
    end
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        break
    end

    kch=vbl_.block;
    tim(kbl)=vbl_.bltime;
    
    if tim(kbl) > time(1) & tim(kbl) < time(2)
        vbl_=vbl_headchr(vbl_);
        vel(kbl,:)=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); % p09
        if ictyp >= 2  % modified Nov 2010
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
        if ictyp == 3
            vbl_=vbl_nextch(vbl_);
            pmean=fread(vbl_.fid,npeak,'float32');
        end
        ibin=find(bin>=binmin&bin<=binmax);
        if length(ibin) < 1
            continue
        end
        ibmin=ibin(1);
        ibmax=ibin(length(ibin));
        bin=bin(ibmin:ibmax);
        amp=amp(ibmin:ibmax);
        if ictyp == 3
            pmean=pmean(ibmin:ibmax);
        end
        ibin=find(amp>=thr(1)&amp<=thr(2));
        bin=bin(ibin);
        amp=amp(ibin);
        if ictyp == 3
            pmean=pmean(ibin);
        end
        if ictyp == 3
            vsp=sparse(bin-binmin+1,1,amp+1j*pmean,nbin,1);
            A(:,kbl)=vsp;
        else
            vsp=sparse(bin-binmin+1,1,amp,nbin,1);
            A(:,kbl)=vsp;
        end
    end
end