function sds_=check_sds_conc(outfile)

outfil=0;
if exist('outfile')
    outfil=1;
    fid=fopen(outfile,'w');
end


[file,pnam,fil]=selfile(' ');
    
go=1;
ii=0;
DT=0;
Thole=0;
Nhole=0;
    
while go == 1
    ii=ii+1;

    sds_=sds_open(file);
%     for i = 1:sds_.nch
%         disp(sprintf(' channel %3d  --> %s',i,sds_.ch{i}))
%     end

    lenteor=sds_.point0+sds_.len*sds_.nch*4;

    info=dir(file);

    err=lenteor-info.bytes;
    t0=sds_.t0;
    t0s=t0*86400;
    if ii > 1
        DT=t0s-t0sA;
    else
        Tstart=t0;
    end
    t0sA=t0s+sds_.len*sds_.dt;

    fclose(sds_.fid);
    
    if DT ~= 0
        Nhole=Nhole+1;
        Thole=Thole+DT;
        strtim=mjd2s(t0A);
        str=sprintf('    %f s --> HOLE at %s ',DT,strtim);
        if outfil > 0
            fprintf(fid,'%s \r\n',str);
        else
            disp(str);
        end
    end
    t0A=t0sA/86400;
    
    strtim=mjd2s(t0);
    str=sprintf('%s %s  duration: %f s  chs:',fil,strtim,sds_.len*sds_.dt);
    for i = 1:sds_.nch
        str=[str ' ' sds_.ch{i}];
    end
    strerr=sprintf('  - err = %f',err);
    str=[str strerr];
    
    if outfil > 0
        fprintf(fid,'%s \r\n',str);
    else
        disp(str);
    end
        
    fil=sds_.filspost;
    if strcmp(fil,'#NOFILE')
        go=0;
    end
    file=[sds_.pnam fil];
end

strtim=mjd2s(Tstart);
strtim1=mjd2s(t0A);
Tobs=t0A-Tstart;
if outfil > 0
    fprintf(fid,'\r\n                          Summary \r\n\r\n');
    fprintf(fid,' %d files start: %s  end: %s   Tobs = %f days\r\n\r\n',ii,strtim,strtim1,Tobs);
    fprintf(fid,'   %d holes  of total duration %f s     percentage = %f \r\n\r\n',Nhole,Thole,Thole/(86400*Tobs));
    fclose(fid);
else
    str=sprintf('\r\n                          Summary \r\n\r\n');
    disp(str);
    str=sprintf(' %d files start: %s  end: %s   Tobs = %f days\r\n\r\n',ii,strtim,strtim1,Tobs);
    disp(str);
    str=sprintf('   %d holes  of total duration %f s     percentage = %f \r\n\r\n',Nhole,Thole,Thole/(86400*Tobs));
    disp(str);
end
