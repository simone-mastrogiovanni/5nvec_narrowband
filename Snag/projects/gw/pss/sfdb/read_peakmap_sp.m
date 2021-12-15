function [A tim vel vbl_]=read_peakmap_sp(list,frband,thr,time,icamp)
%READ_PEAKMAP_SP  reads a vbl-file peakmap to obtain short spectra
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
% In a vbl-file, type 3, the sixth channel is the peak mean.
%
%   list      vbl files list
%   frband    [min,max] frequency; =0 all
%   thr       [min,max] threshold (mjd); =0 all
%   time      [min,max] time (mjd); =0 all
%   icamp     amplitude (1 -> CR, 2 -> amp, 3 -> both (complex))
%
%   A         output (a gd2 sparse, with velocities)

% Version 2.0 - March 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

isp0=0;
isp=0;

if ~exist('icamp','var')
    icamp=1;
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

ictyp=1;

fidlist=fopen(list,'r');
nfiles=0; 

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});disp(str)

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
    end

    vbl_.nextblock=0;
    len=vbl_.len;
    if len == 0
        disp('*** No length - cut at 1000')
        len=1000;
    end
    vel1=zeros(len,6);
    tim1=zeros(1,len);
    B=sparse(nbin,len); %nbin,len
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
        tim1(kbl)=vbl_.bltime;

        if tim1(kbl) > time(1) & tim1(kbl) < time(2)
            vbl_=vbl_headchr(vbl_); % r 1
            vel1(kbl,:)=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); % p09 % r 
            if ictyp >= 2  % modified Nov 2010
                vbl_=vbl_nextch(vbl_); % r 2
                lensp=vbl_.ch0.lenx;
                inisp=vbl_.ch0.inix;
                dfsp=vbl_.ch0.dx;
                sp=fread(vbl_.fid,lensp,'float32'); % r 
                isp=isp+1;
                if sum(sp) == 0
                    isp0=isp0+1;
                end
                vbl_=vbl_nextch(vbl_); % r 3
            end
            vbl_=vbl_nextch(vbl_); % r 4
            npeak=vbl_.ch0.lenx;
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
            ibin1=find(bin > 0);  %!!!!! exclude negative frequencies
            bin=bin(ibin1);
            amp=amp(ibin1);
            if ictyp == 3
                pmean=pmean(ibin);
            end
%             if icamp == 1
%                 vsp=sparse(bin-binmin+1,1,amp,nbin,1);
%             elseif icamp == 2
%                 vsp=sparse(bin-binmin+1,1,pmean,nbin,1);  
%             else
%                 vsp=sparse(bin-binmin+1,1,amp+1j*pmean,nbin,1);   
%             end
%             B(:,kbl)=vsp;
        end
    end
    %len,size(B),size(tim1)
    if nfiles == 1
        A=B;
        tim=tim1;
        vel=vel1';
    else
        A=[A B];
        tim=[tim tim1];
        vel=[vel vel1'];
    end
    fclose(vbl_.fid);
end

isp,isp0
[n1 n2]=size(A);
A=gd2(A');
tim0=floor(tim(1));
cont.tim0=tim0;
cont.inifr=vbl_.ch(4).inix;
cont.dfr=vbl_.ch(4).dx;
A=edit_gd2(A,'type',2,'x',tim-tim0,'ini2',frband(1),'dx2',dfr,'cont',cont);

fprintf('Peakmap: mjd = %f, %f (%d values %d days) \n          fr = %f, %f Hz (%d values)\n',...
    min(tim),max(tim),n2,ceil(max(tim))-floor(min(tim)),frband,n1);