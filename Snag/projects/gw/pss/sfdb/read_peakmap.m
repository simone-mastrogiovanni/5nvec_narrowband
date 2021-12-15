function [A,basic_info,checkA]=read_peakmap(list,frband,thr,time,runstr)
% function [A tim vel shsp pmean vbl_]=read_peakmap(list,timtyp,frband,thr,time,runstr)
%READ_PEAKMAP  reads a vbl-file peakmap
%                 updated to support v09 format
%
% In a vbl-file, type 1, the first channel is the velocity, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
% In a vbl-file, type 2, the first channel is the velocity, the second the short spectrum
% (unilateral, in Einstein^2),
% the third the index to the peakbin (for direct access), the fourth the frequency bins 
% (the peakbin), the fifth the CR.
%
% In a vbl-file, type 3, the sixth channel is the peak mean.
%
%   list      vbl files list
%   timtyp    'center','beginning' or number of seconds of delay
%   frband    [min,max] frequency; =0 all
%   thr       [min,max] threshold (mjd); =0 all
%   time      [min,max] time (mjd); =0 all
%   runstr    run structure
%
%   A            output (a gd2 sparse, with velocities)
%   basic_info   all constants for the job

% Version 2.0 - November 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

tic
checkA=struct();
if frband == 0
    frband=[0 1000000];
end
if thr == 0
    thr=[0 1e100];
end
if time == 0
    time=[0 1000000];
end

dfr=runstr.fr.dnat;
enl1=round(frband(1)*2e-4/dfr)*dfr;
enl2=round(frband(2)*2e-4/dfr)*dfr;
frband1=[frband(1)-enl1 frband(2)+enl2];

timtyp='center';

basic_info.proc.A_read_peakmap.vers='140630';
basic_info.proc.A_read_peakmap.list=list;
basic_info.proc.A_read_peakmap.frband=frband;
basic_info.proc.A_read_peakmap.thr=thr;
basic_info.proc.A_read_peakmap.time=time;
basic_info.proc.A_read_peakmap.tim=datestr(now);

basic_info.run=runstr;

ictyp=1;
shsp=struct;
pmean=0;
lentot=0;

fidlist=fopen(list,'r');
nfiles=0;
npea0=0;
npea1=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});disp(str)
    if length(file{nfiles})<2
        continue
    end
    if nfiles >= 2
        fclose(vbl_.fid);
    end
    vbl_=vbl_open(file{nfiles});

    if nfiles == 1
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
            ichsp=2;
            ichcr=5;
            dfr=vbl_.ch(ich).dx;
            lfft=vbl_.ch(ich).lenx*2;
            ictyp=2;
        elseif vbl_.nch == 6
            disp('Type 3 peakmap file')
            ich=4;
            ichsp=2;
            ichcr=5;
            ichpm=6;
            dfr=vbl_.ch(ich).dx;
            lfft=vbl_.ch(ich).lenx*2;
            ictyp=3;
        else
            disp('*** Attention ! strange vbl file')
        end
        
        if ischar(timtyp)
            if strcmpi(timtyp,'center')
                timdel=1/(vbl_.ch(ich).dx*2);
            end
            if strcmpi(timtyp,'beginning')
                timdel=0;
            end
        else
            timdel=timtyp;
        end
        
        disp(sprintf('Delay %f s',timdel))

        binmin=floor(frband1(1)/dfr);
        binmax=ceil(frband1(2)/dfr);

        nbin=binmax-binmin+1;
        if nbin > lfft/2
            nbin=lfft/2;
        end
    end

    vbl_.nextblock=0;
    len=vbl_.len;
    lentot=lentot+len;
    if len == 0
        disp('*** No length - cut at 1000')
        len=1000;
    end
    vel1=zeros(len,6);
    tim1=zeros(1,len);
    npeak_fft1=tim1;
    B=sparse(nbin,len); %nbin,len
    Bpm=sparse(nbin,len);
    kbl=0;

    while vbl_.eof == 0
        kbl=kbl+1;
        if kbl > len
            break
        end
        vbl_=vbl_nextbl(vbl_); % r bloc
        if vbl_.eof > 0
            break
        end

        kch=vbl_.block;
        tim1(kbl)=vbl_.bltime+timdel/86400;

        if tim1(kbl) > time(1) & tim1(kbl) < time(2)
            vbl_=vbl_headchr(vbl_); % r 1
            vel1(kbl,:)=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); % p09 % r 
            if ictyp >= 2  % modified Nov 2010
                vbl_=vbl_nextch(vbl_); % r 2
                lensp=vbl_.ch0.lenx;
                inisp=vbl_.ch0.inix;
                dfsp=vbl_.ch0.dx;
                sp=fread(vbl_.fid,lensp,'float32'); % r 
                isp1=max(floor((frband1(1)-inisp-2)/dfsp),0)+1;
                isp2=min(floor((frband1(2)-inisp+2)/dfsp),lensp-1)+1;
                frminsp=isp1*dfsp;
                frmaxsp=isp2*dfsp;
                sp=sp(isp1:isp2);
                vbl_=vbl_nextch(vbl_); % r 3
                if kbl == 1
                    Bsp=zeros(isp2-isp1+1,len);
                end
            end
            vbl_=vbl_nextch(vbl_); % r 4
            npeak=vbl_.ch0.lenx;
            npeak_fft1(kbl)=npeak;
            bin=fread(vbl_.fid,npeak,'int32'); % r 
            vbl_=vbl_nextch(vbl_); % r 5
            amp=fread(vbl_.fid,npeak,'float32'); % r 
            if ictyp == 3
                vbl_=vbl_nextch(vbl_); % r 6
                pmean=fread(vbl_.fid,npeak,'float32'); % r 
            end
            ibin=find(bin>=binmin & bin<=binmax);
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
            npea0=npea0+length(bin);
            ibin1=find(bin > 0);  %!!!!! excludes negative frequencies
            npea1=npea1+length(ibin1);
            bin=bin(ibin1);
            amp=amp(ibin1);
            if ictyp == 3
                pmean=pmean(ibin1);
            end
            vsp=sparse(bin-binmin+1,1,amp,nbin,1);
            B(:,kbl)=vsp;%fprintf('%d  %d   %d \n',length(bin),length(pmean),length(bin)-length(pmean))
            Bsp(:,kbl)=sp;%kbl,size(pmean),size(amp),length(bin),binmin,nbin
            pm=sparse(bin-binmin+1,1,pmean,nbin,1); %figure,plot(vsp),figure,plot(pmean),pause
            Bpm(:,kbl)=pm;
        end
    end
    %len,size(B),size(tim1)
    if nfiles == 1
        A=B;
        Asp=Bsp;
        Apm=Bpm;
        tim=tim1;
        npeak_fft_full=npeak_fft1;
        vel=vel1';
    else
        A=[A B];
        Asp=[Asp Bsp];
        Apm=[Apm Bpm];
        tim=[tim tim1];
        npeak_fft_full=[npeak_fft_full npeak_fft1];
        vel=[vel vel1'];
    end
end

[n1 n2]=size(A);
A=gd2(A');
pmean=Apm';
tim0=floor(tim(1));
cont.tim0=tim0;
cont.inifr=vbl_.ch(4).inix;
cont.dfr=vbl_.ch(4).dx;
cont.vp=vel;
shsp.nfr=isp2-isp1+1;
shsp.ntim=lentot;
shsp.frini=frminsp;
shsp.dfr=dfsp;
gsp=gd2(Asp');
gsp=edit_gd2(gsp,'x',tim-tim0,'ini2',frminsp,'dx2',dfsp);

cont.pmean=pmean;
cont.gsp=gsp;
cont.runstr=runstr;

A=edit_gd2(A,'x',tim-tim0,'ini2',frband1(1),'dx2',dfr,'cont',cont);

fprintf('Peakmap: mjd = %f, %f (%d values %d days) \n          fr = %f, %f Hz (%d values)\n',...
    min(tim),max(tim),n2,ceil(max(tim))-floor(min(tim)),frband,n1);

basic_info.tim=tim;
basic_info.tim0=tim0;
basic_info.npeak_fft_full=npeak_fft_full;
basic_info.ntim=length(tim);
basic_info.epoch=mean(tim);
basic_info.frin=frband(1);
basic_info.frfi=frband(2);
basic_info.frin1=frband1(1);
basic_info.dfr=dfr;
basic_info.nfr=n1;
basic_info.velpos=vel;
basic_info.shsp=shsp;
basic_info.gsp=gsp;
basic_info.NPeak(1)=npea0;
basic_info.NPeak(2)=npea1;

basic_info.proc.A_read_peakmap.duration=toc;