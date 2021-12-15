function veto_vbl_pm(filevbl,veto,level,wind,reset)
% VETO_VBL_PM  vetoes the peakmaps on the basis of the h-peaks
%              works inside one decade
%
%      veto_vbl_pm(filevbl,veto,level,wind,reset)
%
%   filevbl    the first vbl pm file
%   veto       the file with the no-Doppler h-peaks
%              alternatively, a veto structure
%   level      threshold (on amplitude) for vetoing (an array with the minimum h-peak
%              amplitude for each spin-down value or a single value for all); def = 0
%   wind       window (in units of dfr; default 1.2)
%   reset      = 1 -> at beginning enables all peaks; default 0
%
%   veto structure:
%
%     veto.fr         should be frequency sorted
%     veto.sd
%     veto.amp
%     veto.fftpar     [min max step]
%     veto.sdpar      [min max step]
%     veto.epoch

% Version 2.0 - October 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ischar(veto)
    veto=pss_read_vetofile;
end

nsd=round((veto.sdpar(2)-veto.sdpar(1))/veto.sdpar(1))+1;

if ~exist('level','var')
    level=0;
end

if length(level) == 1
    level(1:nsd)=level;
end

if ~exist('wind','var')
    wind=1.2;
end
wfr=wind*veto.fftpar(3)/2;

if ~exist('reset','var')
    reset=0;
end

vbl_=vbl_open(file);

if vbl_.nch == 5
    disp('Type 2 peakmap file')
    ich=4;
    ictyp=2;
else
    disp('*** ERROR ! strange vbl file')
    return
end

dfr=vbl_.ch(ich).dx;
lfft=vbl_.ch(ich).lenx*2;
inifr=vbl_.ch(ich).inix;
if dfr == 0
    disp('*** errors in fft parameters; default set')
    return
end

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
    
    vbl_=vbl_headchr(vbl_);
    vel=fread(vbl_.fid,3,'double');
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
%         vsp=sparse(bin-binmin+1,1,amp,nbin,1);
%         spfr=spfr+vsp;
%         peakfr=peakfr+sign(vsp);
%         sptim(kbl)=mean(vsp);
%         peaktim(kbl)=sum(sign(vsp));

end

