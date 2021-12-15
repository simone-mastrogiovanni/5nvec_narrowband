function sds_resume(resfile,minhole,file,chn,freqs)
%SDS_RESUME  creates a resume of sds concatenated files
% 
%     resfile   file containing the resumes (without extention)
%     minhole   minimum hole length (in samples; typically 4096 == 1s)
%               it is also the sampling time for the resumé sds
%     file      first file of a concatenated set
%     chn       channel number
%     freqs     initial band frequencies; a t-type sds file with the bands content is created 
%               if not present, doesn't create the sds output file

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
     
if ~exist('resfile','var')
    resfile='resume';
end
resfiletxt=[resfile '.txt'];
resfilesds=[resfile '.sds'];

if ~exist('file','var') | file == 0
    snag_local_symbols;
    file=selfile('');
end

sds_=sds_open(file);

if ~exist('chn','var')
    chn=sds_selch(file);
end

if ~exist('minhole','var')
    minhole=round(1/sds_.dt);
    if minhole < 100
        minhole=100
    end
end

icfreq=0;
if exist('freqs','var')
    icfreq=1;
end

fid=fopen(resfiletxt,'w');

fprintf(fid,'                SDS Resume \r\n\r\n');
fprintf(fid,'             %s \r\n\r\n',datestr(now));
fprintf(fid,'             Time is UTC, numerical time is MJD \r\n\r\n');

dt=sds_.dt;
t0=floor(sds_.t0);
N_nan=0;
N_nantot=0;
nsamp1=0;

ii=0;
icwrit=1;
ic0=0;
n0=0;
tim1=0;
timhole=0;
nzeros=0;
nholes=0;
nsamp=0;

while 1 > 0
    [vec,sds_,tim0,holes,n_nan]=vec_from_sds(sds_,chn,minhole);
    
    if n_nan > 0
        disp([num2str(n_nan) ' NaN found at ' mjd2s(tim0)]);
        N_nan=N_nan+n_nan;
        N_nantot=N_nantot+n_nan;
    end
    
    if sds_.eof > 1
        break
    end
    
    nsamp=nsamp+length(vec);
    nsamp1=nsamp1+length(vec);
    me=mean(vec);
    
    if ii == 0
        fprintf(fid,'        First file %s \r\n\r\n',sds_.filme);
        fprintf(fid,'    Label :  %s\r\n',char(sds_.label'));
        fprintf(fid,'    Caption :  %s\r\n\r\n',sds_.capt);
        for i = 1:sds_.nch
            fprintf(fid,'  Channel %d :  %s \r\n',i,sds_.ch{i});
        end
        fprintf(fid,'        \r\n\r\n');
        timstart=tim0;
        
        if icfreq == 1
            nfr=length(freqs);
            dfr=1/(sds_.dt*minhole);
            ifrini=freqs/dfr+1;
            ifrfin(1:nfr-1)=ifrini(2:nfr)-1;
            ifrfin(nfr)=minhole/2;
            sdsw_.dt=sds_.dt*minhole;
            sdsw_.t0=t0;
            sdsw_.nch=nfr+1;
            sdsw_.ch{1}='timing channel';
            for i = 1:nfr
                sdsw_.ch{i+1}=sprintf('band %f - %f ',(ifrini(i)-1)*dfr,(ifrfin(i)*dfr));
            end
            sdsw_=sds_openw(resfilesds,sdsw_);
        end
    end
    
    if icwrit > 0
        if tim1 > 0
            fprintf(fid,'      hole of %f hours \r\n',(tim0-tim1)*24);
            timhole=timhole+tim0-tim1;
            nholes=nholes+1;
        end
        fprintf(fid,'file %s start at %f (%s) \r\n',sds_.filme,tim0,mjd2s(tim0));
        nsamp1=0;
        timstart1=tim0;
        icwrit=0;
        n0=0;
    end
    
    if holes.end > 0
        icwrit=1;
        if N_nan > 0
            fprintf(fid,'      found %d NaNs on %d samples \r\n',N_nan,nsamp1);
            N_nan=0;
        end
        fprintf(fid,'      stop at %f (%s) ; %d samples found \r\n',tim1,mjd2s(tim1),nsamp);
        n0=0;
        nsamp=0;
    end
    
    if std(vec) > 0
        nzeros=nzeros+n0;
        if n0 > 0
            fprintf(fid,'      constant input at %f for %d samples \r\n',tim00,n0);
            nholes=nholes+1;
        end
        ic0=0;
        n0=0;
    else
        if n0 == 0
            tim00=tim0;
        end
        ic0=1;
        n0=n0+minhole;
    end
    
    if icfreq == 1
        fvec=abs(fft(vec-me)).^2;
        for i = 1:nfr
            fout(i)=sum(fvec(ifrini(i):ifrfin(i)))*dfr*10^40;
        end
        fwrite(sdsw_.fid,tim0-t0,'float');
        fwrite(sdsw_.fid,fout,'float');
    end
    
    ii=ii+1;
    tim1=tim0+dt*minhole/86000;
end

if n0 > 0
    fprintf(fid,'      constant input at %f for %d samples \r\n',tim00,n0); 
end
fprintf(fid,'      stop at %f \r\n\r\n',tim1);

timobs=tim1-timstart;
fprintf(fid,'      Total observation time %f days (%f hours)\r\n',timobs,timobs*24);

fprintf(fid,'      hole time %f days (%f hours)\r\n',timhole,timhole*24);

timzero=nzeros*dt/86400;
fprintf(fid,'      zero time %f days (%f hours)\r\n\r\n',timzero,timzero*24);
fprintf(fid,'      Total number of holes (or zeroed segments) %d \r\n',nholes);
fprintf(fid,'      Total number of NaN %d \r\n',N_nantot);

fclose(fid);
if icfreq == 1
    fclose(sdsw_.fid);
end