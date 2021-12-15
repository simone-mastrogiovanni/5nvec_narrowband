function [iok sbl_ dt0all phall phall1]=sfdb09_band2sbl_old(freq,cont,folder,pialist,filesbl,simpar)
%SFDB09_BAND2SBL  puts in a sbl files a band of sfdb09
%     the output file is single, except in the case of whole band
%
%    [iok head]=sfdb_band2sbl(freq,cont,folder,pialist,filesbl,simpar)
%
%   freq        frequency band [min max] (rough); n -> whole band, n is the number of blocks per file
%   cont        output file content: 1 -> only data 
%                                    2 -> data and velocity/position (double)
%                                    3 -> data, velocity/position (double) and short spectrum band
%   folder      folder containing the input pia files
%   pialist     pia file list (obtained with dir /b/s > list.txt in the parent dir) 
%   filesbl     file sbl to create; if simX.sbl -> simulation :
%                         sim0.sbl  only sinusoid, classical
%                         sim1.sbl  only sinusoid, frequency domain
%                         sim2.sbl  data plus sinusoid
%                         sim3.sbl  white noise
%                         sim4.sbl  only source, naive
%                         sim5.sbl  only source, fine
%                         sim6.sbl  data + source, fine
%   simpar      simulation parameters (e.g.: [frequency amplitude] or {source antenna ampltude})
%
%   iok         = 0 -> error
%   head        header of the output file
%
%  NOTES: 
%         in sbl_.dt there is the normal time between 2 ffts
%         attention at firstfrind
% 
% piahead.einstein=fread(fid,1,'float32');  %
%
% piahead.detector=fread(fid,1,'int32');    % detector (0,1)
% piahead.tsamplu=fread(fid,1,'double');    % original sampling time
% piahead.typ=fread(fid,1,'int32');         % interlacing (0, 2)
%
% piahead.wink=fread(fid,1,'int32');        % window type
% piahead.nsamples=fread(fid,1,'int32');    % number of samples of fft
% piahead.tbase=fread(fid,1,'double');      % length of fft in s
% piahead.deltanu=fread(fid,1,'double');    % fft frequency bin
% piahead.firstfrind=fread(fid,1,'int32');  % first index (e.g.: 0)
% piahead.frinit=fread(fid,1,'double');     % initial frequency 
% piahead.normd=fread(fid,1,'float32');       % factor |fft|^2 -> pow spect
% piahead.normw=fread(fid,1,'float32');       % factor window (to be multiplied for normd)
% 
% piahead.red=fread(fid,1,'int32');         % reduction factor (very short spectrum)

% Version 2.0 - December 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

format long
wholban=0;
noutblock=0;
if length(freq) == 1
    wholban=1;
    noutblock=freq;
end
fidlist=fopen([folder pialist]);
tline=fgetl(fidlist);
nfil=0;

dt0all=[];
phall=[];

while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

icdata=1;
nbl=0;

switch filesbl
    case 'sim0.sbl'  % simpar double array
        icdata=0;
        icsim=0;
        simfr=simpar(1);
        if length(simpar) > 1
            simamp=simpar(2);
        else
            simamp=1;
        end
    case 'sim1.sbl'  % simpar double array
        icsim=1;
        icdata=0;
        simfr=simpar(1);
        if length(simpar) > 1
            simamp=simpar(2);
        else
            simamp=1;
        end
    case 'sim2.sbl'  % simpar double array
        icsim=2;
        icdata=1;
        simfr=simpar(1);
        if length(simpar) > 1
            simamp=simpar(2);
        else
            simamp=1;
        end
    case 'sim3.sbl'  % simpar double array
        icsim=3;
        icdata=0;
        simfr=simpar(1);
        if length(simpar) > 1
            simamp=simpar(2);
        else
            simamp=1;
        end
    case 'sim4.sbl'  % simpar double array
        icsim=4;
        icdata=0;
        simfr=simpar(1); % -1 = vela
        if length(simpar) > 1
            simamp=simpar(2);
        else
            simamp=1;
        end
    case 'sim5.sbl' % simpar cell array
        icsim=5;
        icdata=0;
        simfr=-1000;
        simsour=simpar{1};  
        antenna=simpar{2}; %  1 = virgo
        
        if length(simpar) > 2
            simamp=simpar{3};
        else
            simamp=1;
        end
        source1=simsour;
        source1.eps=1;
        source1.psi=0;
        source2=simsour;
        source2.eps=1;
        source2.psi=45;

        nsid=1000;
        dsid=24/nsid;
        sid1=zeros(1,nsid);
        sid2=sid1;
        for i = 1:nsid
            tsid=i*dsid;
            sid1(i)=lin_radpat_interf(source1,antenna,tsid);
            sid2(i)=lin_radpat_interf(source2,antenna,tsid);
        end
        eps=simsour.eps;
        psi=simsour.psi*pi/180;
        fi=2*psi;
        rot=1;
        if psi < 0
            rot=-1;
            psi=psi+90;
        end
    case 'sim6.sbl' % simpar cell array
        icsim=5;
        icdata=1;
        simfr=-1000;
        simsour=simpar{1};  
        antenna=simpar{2}; %  1 = virgo
        
        if length(simpar) > 2
            simamp=simpar{3};
        else
            simamp=1;
        end
        source1=simsour;
        source1.eps=1;
        source1.psi=0;
        source2=simsour;
        source2.eps=1;
        source2.psi=45;

        nsid=1000;
        dsid=24/nsid;
        sid1=zeros(1,nsid);
        sid2=sid1;
        for i = 1:nsid
            tsid=i*dsid;
            sid1(i)=lin_radpat_interf(source1,antenna,tsid);
            sid2(i)=lin_radpat_interf(source2,antenna,tsid);
        end
        eps=simsour.eps;
        psi=simsour.psi*pi/180;
        fi=2*psi;
        rot=1;
        if psi < 0
            rot=-1;
            psi=psi+90;
        end
    otherwise
        icsim=-1;
end

if icsim == 4
    if simfr == -1
        simsour=vela();
        r=astro2rect([simsour.a simsour.d],0);
        fr0=simsour.f0;
    end
end
            

for i = 1:nfil
    file=filepia{i};
    disp(file)
    fidpia=fopen([folder file]);

    if fidpia <= 0
        disp([file ' not opened'])
        piahead=0;data=0;
        return
    end

    iok=1;
    [piahead,tps,sps,sft]=pia_read_block_09(fidpia);
    if ~isstruct(piahead)
        iok=0;
        disp(' *** ERROR !')
        return
    end
    inan=check_nan(sft,1);
    sft(inan)=0;

    inifr0=piahead.firstfrind*piahead.deltanu;
    finfr0=(piahead.nsamples-1)*piahead.deltanu+inifr0;
    if wholban == 1
        freq(1)=inifr0;
        freq(2)=finfr0;
    end
    k1=floor(freq(1)/piahead.deltanu+0.0001)+1;
    fr1=(k1-1)*piahead.deltanu;% k1,freq(1),piahead.deltanu,fr1
    k2=round(freq(2)/piahead.deltanu)+1;
    if floor((k2-k1)/2)*2 == k2-k1
        k2=k2+1;
    end
    fr2=(k2-1)*piahead.deltanu;
    frs1=max(fr1-10,inifr0);
    ks1=round(frs1/(piahead.deltanu*piahead.red));
    frs2=min(fr2+10,finfr0);
    ks2=round(frs2/(piahead.deltanu*piahead.red));
    sft=sft(k1:k2);
    
    tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
    mjd=gps2mjd(tbl);
    % sbhead=[piahead.firstfrind/piahead.tbase 0];
    sbhead2=[0 0];
    
    if i == 1
        fr1,fr2
        sbl_.nch=cont;
        sbl_.len=0; 
        sbl_.capt='band from sfdb files';
        % ch(1).dx=1/piahead.tbase;
        switch cont
            case 1
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';
                
                sbhead1=[fr1 0];
            case 2
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';

                ch(2).dx=0;
                ch(2).dy=0;
                ch(2).lenx=6;
                ch(2).leny=1;
                ch(2).inix=0;
                ch(2).iniy=0;
                ch(2).type=6;
                ch(2).name='detector velocity and position';
                
                
                sbhead1=[fr1 0];
            case 3
                ch(1).dx=piahead.deltanu;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';

                ch(2).dx=0;
                ch(2).dy=0;
                ch(2).lenx=6;
                ch(2).leny=1;
                ch(2).inix=0;
                ch(2).iniy=0;
                ch(2).type=6;
                ch(2).name='detector velocity and position';

                ch(3).dx=piahead.deltanu*piahead.red;
                ch(3).dy=0;
                ch(3).lenx=ks2-ks1+1;
                ch(3).leny=1;
                ch(3).inix=frs1;
                ch(3).iniy=0;
                ch(3).type=4;
                ch(3).name='short power spectrum';
                
                
                sbhead1=[fr1 0];   
                sbhead3=[frs1 0];
        end

        sbl_.ch=ch;
        sbl_.t0=mjd;
        t0=mjd;
        dtori=piahead.tsamplu;
        lfftori=piahead.nsamples*2;
        sbl_.dt=piahead.tbase;
        if piahead.typ == 2
            sbl_.dt=sbl_.dt/2;
        end

        sbl_.userlen=80;
        sbl_=sbl_openw(filesbl,sbl_);
        
        sbl_=crea_user(sbl_,piahead);
        
        fid=sbl_.fid;
        
        if icsim > 3
            sour=new_posfr(simsour,t0);
            f0=sour.f0;
            df0=sour.df0;
            ddf0=sour.ddf0;
            fr0=f0
        end
    end

    while piahead.eof == 0
        nbl=nbl+1;
        sbl_headblw(fid,nbl,mjd);
        
        if icsim >= 0
            Dt0=(mjd-t0)*86400; % disp(mjd-t0)
            if icsim > 3
                if simfr < 0
                    format long
                    teph=mjd+sbl_.dt/86400; % time at center+1 sample
                    sour1=new_posfr(simsour,teph);
                    r=astro2rect([sour1.a sour1.d],0);
                    fr0=sour1.f0;
%                     dfr0=sour1.df0*dt;
                    Dt0=(mjd-t0)*86400; % disp(mjd-t0)
                    v(1)=piahead.vx_eq; 
                    v(2)=piahead.vy_eq; 
                    v(3)=piahead.vz_eq;
                    p(1)=piahead.px_eq; 
                    p(2)=piahead.py_eq; 
                    p(3)=piahead.pz_eq;
                    pos1=p(1)+v(1)*dtori*(0:lfftori-1);
                    pos2=p(2)+v(2)*dtori*(0:lfftori-1);
                    pos3=p(3)+v(3)*dtori*(0:lfftori-1);
                    pos=pos1*r(1)+pos2*r(2)+pos3*r(3);
                end
            end
            switch icsim
                case 0
                    ph=simfr*(Dt0+dtori*(0:lfftori-1))*2*pi; 
                    dt0all(nbl)=Dt0;
                    phall(nbl)=ph(1);
                    phall1(nbl)=ph(lfftori);
                    sim=sin(mod(ph,2*pi))*simamp;
                    sim=fft(sim);
                    sim=sim(k1:k2);
        %             sft=sft+sim';
                    sft=sim.';
                case 1
                case 2
                case 3
                case 4
                    tt=Dt0+dtori*(0:lfftori-1);
                    ph1=(f0*tt+df0*tt/2.^2+ddf0*tt.^3/6)*2*pi;
                    ph=fr0*pos*2*pi+ph1; 
                    dt0all=[dt0all pos(1:1000:length(pos)/2)];
                    phall=[phall ph(1:1000:length(ph)/2)];
                    phall1(nbl)=ph(lfftori);
                    sim=sin(mod(ph,2*pi))*simamp;
                    sim=fft(sim);
                    sim=sim(k1:k2);
        %             sft=sft+sim';
                    sft=sim.';
                case 5
                    tt=Dt0+dtori*(0:lfftori-1);
                    ph1=(f0*tt+df0*tt/2.^2+ddf0*tt.^3/6)*2*pi;
                    ph=mod(fr0*pos*2*pi+ph1,2*pi);
                    st=gmst(mjd);
                    i1=mod(round(st*(nsid-1)/24),nsid-1)+1;
                    
                    xc=cos(ph+fi)*(1-eps)/sqrt(2); 
                    yc=sin(ph+fi)*(1-eps)/sqrt(2);
                    xl=cos(ph)*sqrt(eps)*cos(2*psi);
                    yl=cos(ph)*sqrt(eps)*sin(2*psi);
                    sim=(sid1(i1)*(xc+xl)+rot*sid2(i1)*(yc+yl))*simamp;
                    
                    sim=fft(sim);
                    sim=sim(k1:k2);
                    sft=icdata*sft+sim.';
            end
        end
        
        switch cont
            case 1
                sbl_write(fid,sbhead1,5,sft);
            case 2
                sbl_write(fid,sbhead1,5,sft);
                sbl_write(fid,sbhead1,6,[piahead.vx_eq piahead.vy_eq piahead.vz_eq ...
                    piahead.px_eq piahead.py_eq piahead.pz_eq]);
            case 3
                sbl_write(fid,sbhead1,5,sft);
                sbl_write(fid,sbhead1,6,[piahead.vx_eq piahead.vy_eq piahead.vz_eq ...
                    piahead.px_eq piahead.py_eq piahead.pz_eq]);
                sbl_write(fid,sbhead1,4,sps(ks1:ks2));
        end
        [piahead,tps,sps,sft]=pia_read_block_part_09(fidpia,k1,k2);%piahead
        if piahead.eof == 0
            tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
            mjd=gps2mjd(tbl);
        end
        inan=check_nan(sft,1);
        sft(inan)=0;
    end

    fclose(fidpia);
end

nbl
fseek(fid,24,'bof');
fwrite(fid,nbl,'uint32');
fclose(fid);


function sbl_=crea_user(sbl_,piahead)

fid=sbl_.fid; % piahead

fwrite(fid,10^-20,'float32');
fwrite(fid,piahead.detector,'int32');
fwrite(fid,piahead.tsamplu,'double');
fwrite(fid,piahead.typ,'int32');
fwrite(fid,piahead.wink,'int32');
fwrite(fid,piahead.nsamples,'int32');
fwrite(fid,piahead.tbase,'double');
fwrite(fid,piahead.deltanu,'double');
fwrite(fid,piahead.firstfrind,'int32');
fwrite(fid,piahead.frinit,'double');
fwrite(fid,piahead.normd,'float32');
fwrite(fid,piahead.normw,'float32');
fwrite(fid,piahead.red,'int32');
fwrite(fid,[0 0 0],'int32');
        