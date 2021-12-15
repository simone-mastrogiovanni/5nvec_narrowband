function [gdout iok sbl_ dt0all phall phall1]=sfdb09_band2sbl_rad2(freq,cont,folder,pialist,filesbl,simpar,dtout)
%SFDB09_BAND2SBL  puts in a sbl files a band of sfdb09
%     the output file is single, except in the case of whole band
%
% !!!   WITH SQRT(2) CORRECTION FOR SFDB09 CREATED BEFORE 15 APRIL 2010 
% !!!   for sfdb09 files created after, use sfdb09_band2sbl
%
%    [gdout iok sbl_ dt0all phall phall1]=sfdb_band2sbl(freq,cont,folder,pialist,filesbl,simpar,dtout)
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
%                         sim7.sbl  white noise + source, fine (4th par of simpar)
%   simpar      simulation parameters (e.g.: [frequency amplitude] or {source antenna ampltude})
%   dtout       sampling time for output gd
%
%   gdout       output time domain data (if dtout is present)
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

FACT1ONSQRT2=1/sqrt(2); % correct a factor due to the function gd2sfdbfile 

if ~exist('dtout','var')
    dtout=0;
end
gdout=[];

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

tstr=snag_timestr(now);
fidlog=fopen(['sfdb09_band2sbl_' tstr '.log'],'w');
fprintf(fidlog,'Operating on file list %s at %s \n\n',[folder pialist],tstr);
fprintf(fidlog,'   File output %s \n',filesbl);

dt0all=[];
phall=[];

while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

icdata=1;
nbl=0;
icwhite=0;

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
        antenna=simpar{2}; %%  1 = virgo
        
        if length(simpar) > 2
            simamp=simpar{3};
        else
            simamp=1;
        end

        nsid=10000;
        [A0 A45 Al Ar sid1 sid2]=check_ps_lf(simsour,antenna,nsid);
        
        eta=simsour.eta;
        psi=simsour.psi*pi/180;
        fi=2*psi;  
        
        Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
        Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));
        
        fprintf(fidlog,'   Simulation type 5 amp,eta,psi %f, %f, %f \n',simamp,eta,psi);
    case 'sim6.sbl' % simpar cell array
        icsim=5;
        icdata=1;
        simfr=-1000;
        simsour=simpar{1};  
        antenna=simpar{2}; %%  1 = virgo
        
        if length(simpar) > 2
            simamp=simpar{3};
        else
            simamp=1;
        end
        nsid=10000;
        [A0 A45 Al Ar sid1 sid2]=check_ps_lf(simsour,antenna,nsid);

        eta=simsour.eta;
        psi=simsour.psi*pi/180;
        fi=2*psi;
        Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
        Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));
        
        fprintf(fidlog,'   Simulation type 6 amp,eta,psi %f, %f, %f \n',simamp,eta,psi);
    case 'sim7.sbl' 
        icsim=5;
        icdata=1;
        icwhite=1;
        simfr=-1000;
        ampnoise=simpar{4};
        simsour=simpar{1};  
        antenna=simpar{2}; %%  1 = virgo
        
        if length(simpar) > 2
            simamp=simpar{3};
        else
            simamp=1;
        end
        nsid=10000;
        [A0 A45 Al Ar sid1 sid2]=check_ps_lf(simsour,antenna,nsid);

        eta=simsour.eta;
        psi=simsour.psi*pi/180;
        fi=2*psi;
        Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
        Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));
        
        fprintf(fidlog,'   Simulation type 6 amp,eta,psi %f, %f, %f \n',simamp,eta,psi);
    otherwise
        icsim=-1;
end

if icsim == 4
    if simfr == -1
        simsour=vela();
        r=astro2rect([simsour.a simsour.d],0);
        f0=simsour.f0;
    end
end
     
kkk=0;
kchunk=0;

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
    sft=sft*FACT1ONSQRT2;
    kchunk=kchunk+1;
    inan=check_nan(sft,1);
    sft(inan)=0;
    chzero=sum(abs(sft));
    if chzero == 0
        fprintf(fidlog,'  Zero input at %f file = %d  chunk %d - removed \n',mjd,i,kchunk);
    end

    if i == 1
        dfr=piahead.deltanu;
        dtfft=piahead.tbase/2;
        mjd1=piahead.mjdtime-dtfft/86400;disp('Set of mjd1');
        
        inifr0=piahead.firstfrind*dfr;
        finfr0=(piahead.nsamples-1)*dfr+inifr0;
        if wholban == 1
            freq(1)=inifr0;
            freq(2)=finfr0;
        end
        k1=floor(freq(1)/dfr+0.0001)+1;
        fr1=(k1-1)*dfr;% k1,freq(1),piahead.deltanu,fr1
        k2=round(freq(2)/dfr)+1;
        if floor((k2-k1)/2)*2 == k2-k1
            k2=k2+1;
        end
        fprintf('k1,k2= %d,%d \n',k1,k2)
        fr2=(k2-1)*dfr;
        frs1=max(fr1-10,inifr0);
        ks1=round(frs1/(dfr*piahead.red));
        frs2=min(fr2+10,finfr0);
        ks2=round(frs2/(dfr*piahead.red));
        
        if dtout > 0
            lfftin=piahead.nsamples*2;
            lfftout0=lfftin*piahead.tsamplu/dtout;
            [d lfftout]=divisors(lfftin,lfftout0);
            dt=1/(lfftout*dfr);
            m4=lfftout/4;
            red=lfftin/lfftout;
           
            kfr=mod(k1-1:k2-1,lfftout)+1;
            xfr=zeros(1,lfftout);
        end
    end
    
    sft=sft(k1:k2);
    mjd=piahead.mjdtime;
    sbhead2=[0 0];
    
    if i == 1
        fr1,fr2
        sbl_.nch=cont;
        sbl_.len=0; 
        sbl_.capt='band from sfdb files';
        % ch(1).dx=1/piahead.tbase;
        switch cont
            case 1
                ch(1).dx=dfr;
                ch(1).dy=0;
                ch(1).lenx=k2-k1+1;
                ch(1).leny=1;
                ch(1).inix=fr1;
                ch(1).iniy=0;
                ch(1).type=5;
                ch(1).name='fft';
                
                sbhead1=[fr1 0];
            case 2
                ch(1).dx=dfr;
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
                ch(1).dx=dfr;
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

                ch(3).dx=dfr*piahead.red;
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
            f00=sour.f0;
            f0=f00;
            df0=sour.df0;
            ddf0=sour.ddf0;
%             fr0=f0
        end
        
        fprintf(fidlog,'   Original parameters: dt,lfft,dfr,dtfft  %f, %d, %f %f \n',dtori,lfftori,dfr,dtfft);
        fprintf(fidlog,'   Output parameters: frq.band,dtout  [%f %f], %f  \n',fr1,fr2,dtout);
    end

    while piahead.eof == 0
        kkk=kkk+1;
        if chzero > 0
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
    %                    f0=sour1.f0;
    %                    Dt0=(mjd-t0)*86400; % disp(mjd-t0)
                        v(1)=piahead.vx_eq; 
                        v(2)=piahead.vy_eq; 
                        v(3)=piahead.vz_eq;
                        p(1)=piahead.px_eq; 
                        p(2)=piahead.py_eq; 
                        p(3)=piahead.pz_eq;
    %                     pos1=p(1)+v(1)*dtori*(0:lfftori-1); %% p(1)+v(1)*dtori*(-lfftori/2:lfftori/2-1)
                        pos1=p(1)+v(1)*dtori*(-lfftori/2:lfftori/2-1);
                        pos2=p(2)+v(2)*dtori*(-lfftori/2:lfftori/2-1);
                        pos3=p(3)+v(3)*dtori*(-lfftori/2:lfftori/2-1);
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
                        ph1=(f0*tt+df0*tt.^2/2+ddf0*tt.^3/6)*2*pi;
                        ph=f0*pos*2*pi+ph1; 
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
                        deinst=rough_deinstein(mjd);
                        ph1=(f0*(1-deinst)*tt+df0*(tt.^2)/2+ddf0*(tt.^3)/6)*2*pi; % simulates frequency with spin-down
                        f0a=f0*(1-deinst)+df0*tt;
                        ph2=f0a.*pos*2*pi;  % Romer
                        ph=mod(ph2+ph1,2*pi);
%                         st=gmst(mjd)+dtori*(0:lfftori-1)/3600+antenna.long/15;
                        st=gmst(mjd)+dtori*(0:lfftori-1)/3600;
                        i1=mod(round(st*(nsid-1)/24),nsid-1)+1;

                        e0=exp(1j*ph);
                        sim=simamp*real((Hp*sid1(i1)+Hc*sid2(i1)).*e0);

                        sim=fft(sim);
                        sim=sim(k1:k2);
                        if icwhite == 1
                            nn=length(sft);
                            sft=(randn(1,nn)+1j*randn(1,nn))*(2^16)*ampnoise/1.4142; % to be generalized
                            sft=sft';
                        end
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

            if dtout > 0 
                hole=((mjd-mjd1)*86400-dtfft)/dt;
                mjd1=mjd;
                ihole=round(hole);
                if abs(hole-ihole) > 1.e-6
                    fprintf(' *** ATTENTION ! gap of %f \n',hole-ihole);
                    fprintf(fidlog,' *** ATTENTION ! gap of %f \n',hole-ihole);
                end
                if ihole > 0
                    gdout=[gdout zeros(1,ihole)];
                    fprintf(' Hole of %f s\n',hole);
                    fprintf(fidlog,' Hole of %f s\n',hole);
                end

                xfr=zeros(1,lfftout);
                xfr(kfr)=sft;
                xt=2*ifft(xfr);

                gdout=[gdout xt(m4+1:3*m4)/red];  
            end
        end
        
        [piahead,~,sps,sft]=pia_read_block_part_09(fidpia,k1,k2);%piahead
        if piahead.eof == 0
            mjd=piahead.mjdtime;
            inan=check_nan(sft,1);
            sft(inan)=0;
            if ~isempty(inan)
                fprintf(' *** %d NaNs',length(inan));
                fprintf(fidlog,' *** %d NaNs \n',length(inan));
            end
        end
        sft=sft*FACT1ONSQRT2;
        kchunk=kchunk+1;
        chzero=sum(abs(sft));
        if chzero == 0
            fprintf(fidlog,'  Zero input at %f file = %d  chunk %d removed \n',mjd,i,kchunk);
        end
    end

    fclose(fidpia);
end

nbl
fseek(fid,24,'bof');
fwrite(fid,nbl,'uint32');
fclose(fid);

if dtout > 0
    gdout=gd(gdout);
    gdout=edit_gd(gdout,'dx',dt);
end

fclose(fidlog);


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
