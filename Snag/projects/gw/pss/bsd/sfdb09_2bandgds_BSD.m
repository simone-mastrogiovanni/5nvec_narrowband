function [g, y, itimes, headers]=sfdb09_2bandgds_BSD(pialist,foldout,frmin,frmax,BSD_BAND,nfft,run,ant,calibration,sim)
%[g, y, itimes, headers]=sfdb09_2bandgds_BSD(pialist,foldout,frmin,frmax,band,nfft,run,ant,calibration,sim)
% Example: sfdb09_2bandgds_BSD('sfdblist.txt',pwd,60,80,10,200,'O1','ligoh','C01',0); --> use real data; 
%
%SFDB09_2BANDGDS  creates BSD gds
%    
%   pialist      input file list of SFDB 
%   foldout      output gds folder
%   frmin,frmax  operation range (depends on the number of gds to manage simultaneously, usually 10 bands)
%                 (for one gd 210 MB are needed)
%   BSD_BAND     frequency bandwidth (and inverse of the sampling time)
%   nfft         number of fft to use (if it is bigger than the total number of ffts in a SFDB file it uses all the ffts in the SFDB file) 
%   run          e.g 'O1','VSR4'
%   ant          e.g 'ligoh', 'ligol', 'virgo'
%   calibration sting e.g. 'C00' or 'C01' indicates the calibration version
%
%   sim           =1 usa solo la sinusoide
%                 diverso da 2 e 1 usa i dati veri altrimenti una sinusoide al posto dei dati 
%                 =2 usa dati+sinusoide
%                 
% HEADER FFT
% piahead.einstein=fread(fid,1,'float32');  %
% piahead.detector=fread(fid,1,'int32');    % detector (0,1)
% piahead.tsamplu=fread(fid,1,'double');    % original sampling time
% piahead.typ=fread(fid,1,'int32');         % interlacing (0, 2)
% piahead.wink=fread(fid,1,'int32');        % window type
% piahead.nsamples=fread(fid,1,'int32');    % number of samples of fft
% piahead.tbase=fread(fid,1,'double');      % length of fft in s
% piahead.deltanu=fread(fid,1,'double');    % fft frequency bin
% piahead.firstfrind=fread(fid,1,'int32');  % first index (e.g.: 0)
% piahead.frinit=fread(fid,1,'double');     % initial frequency 
% piahead.normd=fread(fid,1,'float32');       % factor |fft|^2 -> pow spect
% piahead.normw=fread(fid,1,'float32');       % factor window (to be multiplied for normd)
% piahead.red=fread(fid,1,'int32');         % reduction factor (very short spectrum)

% Version 3.0 - April 2016
%
% From Ornella and Sergio
% Department of Physics - Universita' "Sapienza" - Rome



tic
% SD=86164.09053083288;
% mjd=0;
% p_eq=zeros(4991,4);
% v_eq=p_eq;
%BSD_BAND=10; % Hz
dtout=1/BSD_BAND;
% BDS_MINFR=0;
% BDS_MAXFR=1000;


ngds=round((frmax-frmin)/BSD_BAND);

out.start=datestr(now);

if ~exist('foldout','var')
    foldout='';
end

fidlist=fopen(pialist); %the list of files must contain the entire filepath
tline=fgetl(fidlist); 
nfil=0;
%gd_iname=strcat(tline(1),'_',calibration,'_',tline(21:35)); % L_C00_20151501_074107 parte iniziale del nome del gd
%gd_iname=strcat(tline(1:14));
[~,gd_iname,ext] = fileparts(tline);
switch run
    case 'O1'
        gd_iname=gd_iname(1:14)
    otherwise 
        gd_iname=gd_iname(1:17)
end
tstr=snag_timestr(now);

fidlog=fopen([foldout 'sfdb09_2bandgds_' tstr '.log'],'w');
fprintf(fidlog,'Operating on file list %s at %s \n\n',pialist,tstr);
fprintf(fidlog,'[g, y, fftarray, itimes]=sfdb09_2bandgds_BSD(%s,%s,%f,%d,%d,%d,%s,%f) \n\n',pialist,foldout,dtout,frmin,frmax,nfft,run,sim);


while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

MAX_LEN=max(31,nfil)*BSD_BAND*86400+100000; %31 gg *10 band freq*86400 +100000
g=zeros(ngds,MAX_LEN);  % DA RIVEDERE E GENERALIZZARE
imax=0;

freq12=[frmin:BSD_BAND:(frmax-BSD_BAND); (frmin+BSD_BAND):BSD_BAND:(frmax)]'; %bande freq 

kchunk=0;

for i = 1:nfil                                  %for each SFDB09 file
    file=filepia{i};
    disp(file)

    fidpia=fopen(file);

    if fidpia <= 0
        disp([file ' not opened'])
        %piahead=0;
%         data=0;
        return
    else
        fprintf('File %s opened, fid %d \n',file,fidpia)
    end
    
    ii=0;
       
    while  (~feof(fidpia) && ii<nfft)     % ii< nfft %o eof piahead.eof~=0 feof(fidpia) Ã¨ 0 se il file non Ã¨ finito, se Ã¨ diverso da zero siamo arrivati a fine file % ii indice del blocco
        
    
        [piahead,~,~,sft]=pia_read_block_09(fidpia);
     
        if feof(fidpia)~=0  
            break
        end
        kchunk=kchunk+1;
        ii=ii+1;
        
        if kchunk == 1
            einstein=piahead.einstein;
            dfr=piahead.deltanu;
            dtfft=piahead.tbase/2;
            Tfft=piahead.tbase;                     % time baseline for fft can be 1024,2048,4096,8192 s
            k1=floor(freq12(:,1)/dfr)+1
            k2=floor(freq12(:,2)/dfr)
         
            fr1=(k1-1)*dfr   % k1,freq(1),piahead.deltanu,fr1
            fr2=k2*dfr
           % fprintf('k1,k2= %d,%d,%f,%f \n',k1,k2,fr1,fr2)
        
            lfftin=piahead.nsamples*2; 
            lfftout0=lfftin*piahead.tsamplu/dtout; %dtout output sampling time from input. no sampling =1 lfftout dovrebbe essere la lunghezza della fft finale...ovvero 20480=10*2048!!!
            
            t0=piahead.mjdtime;               % tempo del primo campione del file
            gpst0=piahead.gps_sec;
            lenx=k2-k1+1;                     %lenght of sft band check
            t1=-10^6;
            gpst1=-10^6;
            halftfft=piahead.tbase/2;
 
            nn1=2^ceil(log2(lenx(1))+1);
       
            nn=lfftout0;
            if nn1 > nn
              %  disp(sprintf(' *** Attention ! lfft too short !  lfft,nn1 %d, %d',nn,nn1))
                disp('   Reduce the output sampling time')
            end
            n4=nn/4;
            n2=nn/2;
%           dt=1/(nn*dfr)
            subsampfact=dtout/piahead.tsamplu;
                        %valid ONLY for simulation part!
            %%%%%%%%%%%%%
            %Fs = 4096; 1/Ts       %change            % Sampling frequency 2*fmax, for Tfft=1024s->fmax=2048 Hz-> Fs=4096Hz
            Ts =piahead.tsamplu;                     % Sampling period
            L = Tfft/Ts;                     % Length of signal
            t = (0:L-1)*Ts;                % Time
            fsinus=101.2932;
            f2=108.674;
            %%%%%%%%%%%%%
        
        end
        
        %t2=t1;
        gpst2=gpst1;
        t1=piahead.mjdtime; %should change for each fft
        gpst1=piahead.gps_sec;
        n4s=n4+1;
%       hole=diff_mjd(t2,t1)-halftfft;
        hole=gpst1-gpst2-halftfft;
        if hole > dtout
            n4s=1;
            if hole < halftfft/2
                fprintf('warning hole=%f ,kcunck=%d', hole,kchunk)
                ihole=round(hole/dtout);
                n4s=n4-ihole+1;
            end
        end
%       T1=diff_mjd(t0,t1); 
        T1=gpst1-gpst0;
        ig=floor(T1/dtout)+n4s;   
% 
        itimes(kchunk,1)=ig; 
        itimes(kchunk,2)=T1;
        headers(kchunk,:)=piahead;

        p_eq(kchunk,1)=piahead.px_eq;
        p_eq(kchunk,2)=piahead.py_eq;
        p_eq(kchunk,3)=piahead.pz_eq;

        v_eq(kchunk,1)=piahead.vx_eq;
        v_eq(kchunk,2)=piahead.vy_eq;
        v_eq(kchunk,3)=piahead.vz_eq;
        v_eq(kchunk,4)=piahead.gps_sec;

        for l=1:ngds %numero di sottobandine 
            switch sim
                case 1
                  %    disp('using simulation data') 

                    x=0.5*exp(1j*2*pi*fsinus*(t+T1))+0.5*exp(1j*2*pi*f2*(t+T1));
                    Y = fft(x);           
                    sftt=Y(k1(l):k2(l));
                case 2
                    %  disp('using real data+sinusoid') 

                    x = 0.01*0.5*exp(1j*2*pi*fsinus*(t+T1))+0.01*0.5*exp(1j*2*pi*f2*(t+T1));  
                    Ys = fft(x);
                    sftt=Ys(k1(l):k2(l))+sft(k1(l):k2(l))'; 
                otherwise
            %       disp('using real data')
                    sftt=sft(k1(l):k2(l))';
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             if window==1  %e sim diverso da0 caso solo dati o solo sin  %
%                % disp('using windowing')                                %
%                 w=tukeywin(size(sftt,2),0.01);                          %
%                 sftt=sftt.*w';                                          %
%             end                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %per tutti i casi
            y=ifft(conj(sftt))/subsampfact;
            y=y(n4s:n4+n2);         
            g(l,ig:ig+n2+n4-n4s)=y;
            imax=max(imax,ig+n2+n4-n4s);
        end
    end  
  
    fclose(fidpia);
end

g=g(:,1:imax);

%save;
v_eq(:,4)=v_eq(:,4)-v_eq(1,4)+dtfft;

for l=1:ngds
    pars.t0=t0;
   % pars.t00=floor(t0);
    pars.inifr=freq12(l,1);
    pars.bandw=BSD_BAND;
    pars.v_eq=v_eq;
    p_eq(:,4)=v_eq(:,4);
    pars.p_eq=p_eq;
    pars.Tfft=Tfft;
    pars.ant=ant;
    pars.run=run;
    pars.cal=calibration;
    gg=gd(g(l,:));  
%   Tini=mjd2gps(t0);
    gg=edit_gd(gg,'ini',0, 'dx',dtout, 'cont',pars);
    
    a=freq12(l,1);
    b=freq12(l,2);
    a=num2str(a,'%04d');
    b=num2str(b,'%04d');
    
    gdname=strcat(gd_iname,'_',a,'_',b,'_',run);
    eval([gdname '=gg'])
    gdlongname=strcat(foldout,gdname)
    eval(['save ' gdlongname ' ' gdname ])
end

toc

