function [shortsp vel]=shortsp_peakmap(list,timtyp)
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
% In a vbl-file, type 3, the sixth channel is the peak mean.
%
%   list      vbl files list
%   timtyp    'center','beginning' or number of seconds of delay

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

shsp=struct;
pmean=0;
lentot=0;

fidlist=fopen(list,'r');
nfiles=0; 

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});disp(str)

    vbl_=vbl_open(file{nfiles});

    if nfiles == 1
            disp('Type 3 peakmap file')
            ich=4;
        
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

        vbl_=vbl_headchr(vbl_); % r 1
        vel1(kbl,:)=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); 

        vbl_=vbl_nextch(vbl_); % r 2
        lensp=vbl_.ch0.lenx;
        inisp=vbl_.ch0.inix;
        dfsp=vbl_.ch0.dx;
        sp=fread(vbl_.fid,lensp,'float32'); % r 
        vbl_=vbl_nextch(vbl_); % r 3
        if kbl == 1
            Bsp=zeros(lensp,len);
        end

        vbl_=vbl_nextch(vbl_); % r 4
        npeak=vbl_.ch0.lenx;
        bin=fread(vbl_.fid,npeak,'int32'); % r 
        vbl_=vbl_nextch(vbl_); % r 5
        amp=fread(vbl_.fid,npeak,'float32'); % r 
        
        Bsp(:,kbl)=sp;
    end
    %len,size(B),size(tim1)
    if nfiles == 1
        Asp=Bsp;
        tim=tim1;
        vel=vel1';
    else
        Asp=[Asp Bsp];
        tim=[tim tim1];
        vel=[vel vel1'];
    end
end

shortsp=gd2(Asp');
tim0=floor(tim(1);
cont.t=tim0;
cont.vp=vel;
shortsp=edit_gd2(shortsp,'x',tim-tim0),'ini2',inisp,'dx2',dfsp,'cont',cont);

% fprintf('Peakmap: mjd = %f, %f (%d values %d days) \n          fr = %f, %f Hz (%d values)\n',...
%     min(tim),max(tim),n2,ceil(max(tim))-floor(min(tim)),frband,n1);