function [crfr,crtim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb,sphis,spfr,sptim]=ana_peakmap(frband,thr,time,res,file)
%ANA_PEAKMAP  analyzes a vbl-file peakmap
%
% [spfr,sptim,peakfr,peaktim,npeak,splr,peaklr,mub,sigb,sphis]=ana_peakmap(frband,thr,time,res,file);
%
%   frband           [min,max] frequency; =0 all
%   thr              [min,max] threshold; =0 all
%   time             [min,max] time (mjd); =0 all
%   res              resolution reduction in frequency in low-res maps; =0 no low-res
%   file             input file
%
%   spfr,sptim       mean spectrum vs freq and time
%   crfr,crtim       mean  cr vs freq and time
%   peakfr,peaktim   number of peaks vs freq and time
%   splr,peaklr      t-f peak maxima and number
%   sphis            peak amplitude (CR) histogram
%   mub,sigm         mean,std of peaks in a spectrum
%   npeak            total number of peaks

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file','var')
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
iclr=1;
if res == 0
    iclr=0;
end

vbl_=vbl_open(file);

ictyp=1;

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
inifr=round(vbl_.ch(ich).inix);
if dfr == 0
    disp('*** errors in fft parameters; default set')
%     lfft=4194304
%     dfr=4000/lfft
%     inifr=0;
    return
end

binmin=floor(frband(1)/dfr);binmin
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
spfr=zeros(nbin,1);
crfr=spfr;
peakfr=spfr;
sptim=zeros(len,1);
crtim=sptim;
peaktim=sptim;
tim1=sptim;
splr=zeros(res,len);
peaklr=splr;
sphis=zeros(1,10001);
xhis=0:0.02:200;

mub=zeros(len,1);
sigb=mub;
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
    if floor(kbl/10)*10 == kbl
        disp(kbl)
    end

    kch=vbl_.block;
    tim=vbl_.bltime;
    tim1(kbl)=tim;
    
    if tim > time(1) & tim < time(2)
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
        if length(bin) > 0
            mub(kbl)=mean(bin);
            sig(kbl)=std(bin);
        else
            mub(kbl)=0;
            sig(kbl)=0;
        end
        vbl_=vbl_nextch(vbl_);
        amp=fread(vbl_.fid,npeak,'float32');
        sphis=sphis+hist(amp,xhis);
        hmean=amp*0+1;
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
        iii=find(bin >= nbin);
        if iii > 0
            bin(iii)=1;
        end
        vsp=sparse(bin-binmin+1,1,amp.*hmean,nbin,1);
        spfr=spfr+vsp;%semilogy(spfr./peakfr);pause
        vcr=sparse(bin-binmin+1,1,amp,nbin,1);
        crfr=spfr+vcr;
        crtim(kbl)=mean(vcr);
        peakfr=peakfr+sign(vcr);
        peaktim(kbl)=sum(sign(vcr));
        if iclr > 0
            jj=1;
            vsp=vsp+0;
            for ii = 1:res:(nbin-res)
                aa=mean(vsp(jj:jj+res));
                splr(ii,kbl)=aa;
                peaklr(ii,kbl)=sum(sign(vsp(jj:jj+res)));
                jj=jj+res;
            end
        end
    end
end

spfr=spfr./peakfr;
sptim=sptim./peaktim;
npeak=sum(peakfr);

spfr=gd(spfr);
spfr=edit_gd(spfr,'dx',dfr,'ini',frin,'capt',['time mean of' file]);
crfr=gd(spfr);
crfr=edit_gd(crfr,'dx',dfr,'ini',frin,'capt',['time mean of' file]);
peakfr=gd(peakfr);
peakfr=edit_gd(peakfr,'dx',dfr,'ini',frin,'capt',['peaks vs frequency' file]);
sptim=gd(sptim);
sptim=edit_gd(sptim,'x',tim1,'capt',['time mean of' file]);
crtim=gd(crtim);
crtim=edit_gd(crtim,'x',tim1,'capt',['time mean of' file]);
peaktim=gd(peaktim);
peaktim=edit_gd(peaktim,'x',tim1,'capt',['peaks vs time' file]);
sphis=gd(sphis);
sphis=edit_gd(sphis,'dx',0.02,'capt','peak amplitude histogram');