function sds_reshp_reshape(listin,maxndat,frout,hpfr,nsec,folderin,folderout)
%SDS_RESAM_RESHAPE  from a set of sds files, recreates a new set with different maxlength
%                   with a different sampling time
%
%  the input and output sampling frequencies should be integer numbers
%  for better results, use nsec as a sub-multiple of the typical file length
%
%   listin      list of input file (in a text file, typically in the input folder)
%               "no" -> single file
%   maxndat     maximum number of data per channel (output)
%   frout       output sampling frequency
%   hpfr        high-pass frequency (0 -> n0)
%   nsec        number of "seconds" per piece
%   folderin,folderout  input, output folder (optional - without final slash)
%
% New files are also concatenated.
% All the files should have the same number of channels and same dt.
% Don't use same folder for input and output files !

% Version 2.0 - May 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prefilout='#NOFILE';

if strcmp(listin,'no')
    ic=1;
    nfiles=1;
    filein=selfile('','Input file ?');
    fileout=[filein '_out'];
    maxndat=1e30;
else
    ic=0;
    if ~exist('folderin','var')
        folderin=selfolder('Input files folder');
    end

    if ~exist('folderout','var')
        folderout=folderin;
        while strcmp(folderin,folderout)
            folderout=selfolder('Output files folder',folderin);
            if strcmp(folderin,folderout)
                disp('Don''t use same folder for input and output files !')
            end
        end 
    end

    fid=fopen(listin,'r');
    if fid < 0
        disp([listin ' file could not be opened'])
        return;
    end
    nfiles=0;

    while (feof(fid) ~= 1)
        nfiles=nfiles+1;
        file{nfiles}=fscanf(fid,'%s',1);
        str=sprintf('  %s ',file{nfiles});
        disp(str);
    end

    nfiles=nfiles-1
end

ndatout=0;

for i = 1:nfiles
    if ic == 0
        disp([' --> in ' file{i}]);
        filein=[folderin filesep file{i}];
    end
    sds1=sds_open(filein);
    t1=sds1.t0;
    if t1 > 100000
        disp(' *** time in gps - > corrected');
        t1=gps2mjd(t1);
        sds1.t0=t1;
    end
    if i == 1
        ipiec=1;
        sds0=sds1;
        sds0.len=0;
        nch=sds0.nch;
        dt=sds0.dt;
        t2=t1;
        if ic == 0
            fileout=new_file(file{i},t2);
        end
        
        dtout=1/frout;
        frin=round(1/dt);
        ndat1=nsec*frin;
        ndat2=nsec*frout;
        nd2=min(ndat1,ndat2)/2;
        if hpfr > 0
            nd3=round(ndat1*2*hpfr/frin);
            slop3=12;
            slexp=2;
            hpfr,nd3
        end
        rat=ndat2/ndat1;
        maxndat=round(maxndat/rat);
        rest=maxndat*nch;
        x1=zeros(nch,ndat1*2);
        
        sds0.dt=dtout;
        if ic == 0
            sds2=sds_openw([folderout filesep fileout],sds0);
        else
            sds2=sds_openw(fileout,sds0);
        end
    else
        if sds1.nch ~= nch
            disp([' *** ERROR ! different number of channels in ' file{i}]);
            return
        end
        if sds1.dt ~= dt
            disp([' *** ERROR ! different sampling time in ' file{i}]);
            return
        end
        if abs(t1-t1next) > dt/86400
            %(t1-t1next)*86400/dt
            fileout1=fileout;
            t2=t1;
            fileout=new_file(file{i},t2);
            close_sdsfile(sds2.fid,prefilout,fileout,ndatout/nch);
            prefilout=fileout1;
            sds0.t0=t2;
            sds2=sds_openw([folderout filesep fileout],sds0);
            rest=maxndat*nch;
            ndatout=0;
            ipiec=1;
            x1=zeros(nch,ndat1*2);
        end
    end
    ndataread=0;
    indata=1;
    while indata > 0
        [y,indata]=fread(sds1.fid,ndat1*nch,'float32');
        if indata > 0
            ndataread=ndataread+indata;
            indata1=min(indata,rest);
            ndatout=ndatout+round(indata1*rat);
            
            outdata=round(indata*frout/frin);
            if indata < ndat1*nch
                y(indata+1:ndat1*nch)=0;
            end
            y=reshape(y,nch,ndat1);
            y1=zeros(nch,ndat2);
            x2=zeros(1,ndat2*2);
            for k = 1:nch
                x1(1:ndat1)=x1(ndat1+1:2*ndat1);
                x1(ndat1+1:2*ndat1)=y(k,:);
                x0=fft(x1(k,:));%figure,loglog(abs(x0)),hold on
                if hpfr > 0
                    x0(nd3:-1:1)=x0(nd3:-1:1)./((slop3:nd3+slop3-1)/slop3).^slexp;
                end
                x0(nd2*2:(ndat1-nd2)*2+2)=0;%loglog(abs(x0),'r'),pause
                x0(nd2*2-10:nd2*2-1)=x0(nd2*2-10:nd2*2-1).*(10:-1:1)/10;
                x2(1:nd2*2)=x0(1:nd2*2);
                x2(ndat2*2:-1:(ndat2-nd2)*2+2)=conj(x0(2:nd2*2));
                x2=ifft(x2);
                y1(k,:)=x2(ndat2/2+1:3*ndat2/2);
            end
            ipiec=ipiec+1;
            y1=y1(:);
            
            if ipiec == 1
                fwrite(sds2.fid,y1(ndat2/2+1:outdata)*rat,'float32');
            else
                fwrite(sds2.fid,y1(1:outdata)*rat,'float32');
            end
            rest=rest-indata1;
            if rest <= 0
                fileout1=fileout;
                t2=t2+maxndat*dt/86400;
                fileout=new_file(file{i},t2);
                close_sdsfile(sds2.fid,prefilout,fileout,ndatout/nch);
                prefilout=fileout1;
                sds0.t0=t2;
                sds2=sds_openw([folderout filesep fileout],sds0);
                rest=maxndat*nch;
                indata1=indata-indata1;
                
                ndatout=round(indata1*rat);
                fwrite(sds2.fid,y(1:indata1*nch));
%                 t0=t0+indata1*(sds2.dt/86400);
                rest=rest-indata1;
            end
        end
    end
    
    t1next=t1+(dt/86400)*ndataread/nch;
    fclose(sds1.fid);
end

close_sdsfile(sds2.fid,prefilout,'#NOFILE',ndatout/nch);


function fileout=new_file(filein,t2)

k=findstr(filein,'_');
fileout=filein;
str=mjd2_d_t(t2);
kend=length(k);
fileout(k(kend-2):k(kend))=str;
disp([' <-- out ' fileout]);

function close_sdsfile(fid,prefilout,postfilout,n)

point1=24;
fseek(fid,point1,'bof');
point1=48+128+128*2;
fwrite(fid,n,'int64');
fseek(fid,point1,'bof');
fprintf(fid,'%128s',prefilout);
fprintf(fid,'%128s',postfilout);

fclose(fid);