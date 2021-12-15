function fedsds_resume(resfile,minhole,file,chn)
%FEDSDS_RESUME  creates a resume of sds concatenated files
% 
%     resfile   file containing the resume
%     minhole   minimum hole length (in samples; e.g. 4000 == 1s)
%     file      first file of a concatenated set
%     chn       channel number

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Federica Antonucci & Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome
    
if ~exist('file')
    snag_local_symbols;
    file=selfile('');
end

sds_=sds_open(file);

if ~exist('chn')
    chn=sds_selch(file);
end

if ~exist('minhole')
    minhole=round(1/sds_.dt);
    if minhole < 100
        minhole=100
    end
end

fid=fopen(resfile,'w');

fprintf(fid,'                SDS Resume \r\n\r\n');
fprintf(fid,'             %s \r\n\r\n',datestr(now));
fprintf(fid,'             Time is UTC, numerical time is MJD \r\n\r\n');

dt=sds_.dt;
t0=floor(sds_.t0);

ii=0;
icwrit=1;
ic0=0;
n0=0;
tim1=0;
timhole=0;
nzeros=0;
nholes=0;

while 1 > 0
    [vec,sds_,tim0,holes]=vec_from_sds(sds_,chn,minhole);
    if sds_.eof > 1
        break
    end
    
    if ii == 0
        fprintf(fid,'        First file %s \r\n\r\n',sds_.filme);
        fprintf(fid,'    Label :  \r\n',char('sds_.label'));
        fprintf(fid,'    Caption :  \r\n\r\n',sds_.capt);
        for i = 1:sds_.nch
            fprintf(fid,'  Channel %d :  %s \r\n',i,sds_.ch{i});
        end
        fprintf(fid,'        \r\n\r\n');
        timstart=tim0;
    end
    
    if icwrit > 0
        if tim1 > 0
            fprintf(fid,'      hole of %f hours \r\n',(tim0-tim1)*24);
            timhole=timhole+tim0-tim1;
            nholes=nholes+1;
        end
        fprintf(fid,'file %s start at %f (%s) \r\n',sds_.filme,tim0,mjd2s(tim0));
        icwrit=0;
        n0=0;
    end
	%MODIFICATO FEDE: ho aggiunto   mjd2gps(tim1) 
    if holes.end > 0
        icwrit=1;
        fprintf(fid,'      stop at %f (%s) %f \r\n',tim1,mjd2s(tim1),mjd2gps(tim1));
        n0=0;
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
        ic0==1;
        n0=n0+minhole;
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

fclose(fid);
