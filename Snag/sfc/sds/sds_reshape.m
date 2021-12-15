function sds_reshape(listin,maxndat,multof,folderin,folderout)
%SDS_RESHAPE  from a set of sds files, recreates a new set with different maxlength
%
%   listin    list of input file (in a text file, typically in the input folder)
%   maxndat   maximum number of data per channel
%   multof    the number of data is a multiple of multof (1000 or 1024)
%   folderin, folderout  input, output folder (optional - without final slash)
%
% New files are also concatenated.
% All the files should have the same number of channels and same dt.
% Don't use same folder for input and output files !

% Version 2.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('folderin')
    folderin=selfolder('Input files folder');
end

if ~exist('folderout')
    folderout=selfolder('Output files folder');
    while strcmp(folderin,folderout)
        folderout=selfolder('Output files folder',folderin);
        if strcmp(folderin,folderout)
            disp('Don''t use same folder for input and output files !')
        end
    end 
end

prefilout='#NOFILE';

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

ndatout=0;

for i = 1:nfiles
    disp([' --> in ' file{i}]);
    sds1=sds_open([folderin filesep file{i}]);
    t1=sds1.t0;
    if t1 > 100000
        disp(' *** time in gps - > corrected');
        t1=gps2mjd(t1);
        sds1.t0=t1;
    end
    if i == 1
        sds0=sds1;
        sds0.len=0;
        nch=sds0.nch;
        dt=sds0.dt;
        rest=maxndat*nch;
        t2=t1;
        fileout=new_file(file{i},t2);
        sds2=sds_openw([folderout filesep fileout],sds0);
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
        end
    end
    ndataread=0;
    outdata=1;
    while outdata > 0
        [y,outdata]=fread(sds1.fid,multof*nch,'float32');
        if outdata > 0
            ndataread=ndataread+outdata;
            outdata1=min(outdata,rest);
            ndatout=ndatout+outdata1;
            fwrite(sds2.fid,y(1:outdata1),'float32');
            rest=rest-outdata1;
            if rest <= 0
                fileout1=fileout;
                t2=t2+maxndat*dt/86400;
                fileout=new_file(file{i},t2);
                close_sdsfile(sds2.fid,prefilout,fileout,ndatout/nch);
                prefilout=fileout1;
                sds0.t0=t2;
                sds2=sds_openw([folderout filesep fileout],sds0);
                rest=maxndat*nch;
                outdata1=outdata-outdata1;
                
                ndatout=outdata1;
                fwrite(sds2.fid,y(1:outdata1*nch));
%                 t0=t0+outdata1*(sds2.dt/86400);
                rest=rest-outdata1;
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