function [timfr,dfr,lfft,len]=pia_creatimfr(frband,thr,time,file)
%PIA_CREATIMFR reads a vbl-file peakmap and creates a gd 2 with time in mjd
%and peaks Hz
%
% In a vbl-file the first channel is the parameters, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
%   frband    [min,max] frequency; =0 all
%   thr       [min,max] threshold (mjd); =0 all
%   time      [min,max] time (mjd); =0 all
%   file      input file
%
%   timfr         output (a gd2 , with time (x) and frequencies (y))
%   dfr            frequency resolutin, Hz
%   lfft           length of each FFT
%   len            FFTs total number
% Version xx - 22 August 2007
% by Pia
% E.g. [timfr,dfr,lfft,len]=pia_creatimfr([100,200],0,0);
%
%cd c:\matlab\hough-pia
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

dfr=vbl_.ch(2).dx;
lfft=vbl_.ch(2).lenx*2;
if dfr == 0
    disp('*** errors in fft parameters; default set')
    lfft=4194304
    dfr=4000/lfft
end

binmin=floor(frband(1)/dfr); binmin
binmax=ceil(frband(2)/dfr); binmax
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
 nbin,len
 kbl=0;
 while vbl_.eof == 0
 %%   while kbl <=5   %%prova per fare pochi blocchi ma tutta la banda,
 %%   altrimenti non ce la fa 23/08/07
    kbl=kbl+1;
    if floor(kbl/100)*100 == kbl
        disp(kbl)
    end   
    if kbl > len
        break
    end
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        break
    end

    kch=vbl_.block;
    tim=vbl_.bltime; %%%%%%%time of the block in mjd
    %%tim1(kbl)=tim;   %%put in a vector
    if tim > time(1) & tim < time(2)
        vbl_=vbl_headchr(vbl_);
        vel=fread(vbl_.fid,3,'double');
        vbl_=vbl_nextch(vbl_);
        npeak=vbl_.ch0.lenx;
        bin=fread(vbl_.fid,npeak,'int32'); %%bins of the peaks, at the time tim   bin*dfr is the frequency of the peaks 
        vbl_=vbl_nextch(vbl_);
        amp=fread(vbl_.fid,npeak,'float32'); %%amp of the frequency peaks at the time tim
        ibin=find(bin>=binmin&bin<=binmax);
        if length(ibin) < 1
            continue
        end
        
        ibmin=ibin(1);
        ibmax=ibin(length(ibin));
        bin=bin(ibmin:ibmax);
        amp=amp(ibmin:ibmax);
        clear tim1;
        tim1(1:ibmax-ibmin+1)=tim;
        %whos amp
        %whos bin
        %whos tim1
        ibin=find(amp>=thr(1)&amp<=thr(2));
        bin=bin(ibin);
        tim1=tim1(ibin);
        amp=amp(ibin);
         %%
         if kbl == 1
             timt=tim1;
             bint=bin.';
         end
         if kbl > 1
             timt=[timt tim1];
             bint=[bint bin.'];
         end
              
        %%ricorda che le procedure possibili sui gd sono in @gd. a=x_gd e b=y_gd estraggono ascisse e ordinate 
        %%c= [a b] mette b dopo a !!  e d=c(:) lo mette tutto colonna !!!! 
        %a=[0 1 2 3 4];
        %>> b=[10 11 12 13 14];
         %>> c=[a b]
         %c =  0     1     2     3     4    10    11    12    13    14
     end
 end
    tim_tot=timt(:);
    freq_tot=bint(:)*dfr;
    whos freq_tot
    whos tim_tot
    
%Construct a gd type 2 with frequencies of peaks vs time in mjd
timfr=gd(freq_tot);
timfr=edit_gd(timfr,'x',tim_tot,'capt',['fr peaks vs time in ' file]);
%%%
%timfr %%%scrive la label, dimensioni
%plot(timfr,'.')
%ax=x_gd(timfr);
%ay=y_gd(timfr);