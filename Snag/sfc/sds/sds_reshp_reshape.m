function sds_reshp_reshape(listin,maxndat,frout,hpfr,nsec,folderin,folderout)
%SDS_RESHP_RESHAPE  from a set of sds files, recreates a new set with different maxlength
%                   with a different sampling time; an hp filter is applied
%
%  the input and output sampling frequencies should be integer numbers
%  for better results, use nsec as a sub-multiple of the typical file length
%
%   sds_reshp_reshape(listin,maxndat,frout,hpfr,nsec,folderin,folderout)
%
%   listin      list of input file (in a text file, typically in the input folder)
%               "no" -> single file
%   maxndat     maximum number of data per channel (output) (approximately: it is recomputed)
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
% Department of Physics - Università "Sapienza" - Rome

% variables:
%
%  rest < maxndat*nch  [all ch]
%  ndat1 data input for single action  [single ch]
%  ndat2 data output for single action
%
%  r_in     data read (partial for each input action)  [all ch]
%  r_intot  data read (total for each input action that can be repeated)
%  r_tot              (for each continuous stream)
%  r_tot_fil          (for each input file)
%
%  p_tot    input data processed (for each continuous stream: single channel) [single ch]
%
%  w_out    data output (for each output action)  [all ch]
%  w_tot                (for each continuous stream)
%  w_tot_fil            (for each output file)
%
%  ic_newstream  (0,1) indicates new continuous stream

prefilout='#NOFILE';

if strcmp(listin,'no')
    ic_nolist=1;
    nfiles=1;
    filein=selfile('','Input file ?');
    fileout=[filein '_out'];
    maxndat=1e30;
else
    ic_nolist=0;
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

ic_newstream=1;
w_tot=0;
w_tot_fil=0;

for i = 1:nfiles
    r_tot_fil=0;
    if ic_nolist == 0
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
        sds0=sds1;
        sds0.len=0;
        nch=sds0.nch;
        dt=sds0.dt;
        t2=t1;
        if ic_nolist == 0
            fileout=new_file(file{i},t2);
            w_tot_fil=0;
        end
        
        dtout=1/frout;
        frin=round(1/dt);
        ndat1=nsec*frin;
        ndat1A=ndat1;
        r_tot=0;
        p_tot=0;
        r_intot=0;
        yy=zeros(1,ndat1*nch);
        ndat2=nsec*frout;
        nd2=min(ndat1,ndat2)/2;
        if hpfr > 0
            nd3=round(ndat1*2*hpfr/frin);
            slop3=12;
            slexp=2;
            hpfr,nd3
        end
        rat=ndat2/ndat1; % frout/frin
        maxndat=round(maxndat/ndat2)*ndat2;
        disp(sprintf(' new maxndat : %d ',maxndat))
        rest=maxndat*nch;
        x1=zeros(nch,ndat1*2);
        
        sds0.dt=dtout;
        if ic_nolist == 0
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
            ic_newstream=1;
            close_sdsfile(sds2.fid,prefilout,fileout,w_tot_fil/nch);
            prefilout=fileout1;
            sds0.t0=t2;
            sds2=sds_openw([folderout filesep fileout],sds0);
            rest=maxndat*nch;
            x1=zeros(nch,ndat1*2);
            ndat1A=ndat1;
            w_tot_fil=0;
            w_tot=0;
            r_tot=0;
            p_tot=0;
            r_intot=0;
        end
    end
%     ndataread=0;
    r_in=1;
    while r_in > 0
        [y,r_in]=fread(sds1.fid,ndat1A*nch,'float32');
        if r_in == 0
            break
        end
        ndat1A=ndat1A-r_in/nch;
        yy(r_intot+1:r_intot+r_in)=y;
        r_tot=r_tot+r_in;
        r_tot_fil=r_tot_fil+r_in;
        r_intot=r_intot+r_in;
        if r_intot >= ndat1*nch
            if r_intot > ndat1*nch
                disp(' *** Error ! big r_intot')
            end
            yy=reshape(yy,nch,ndat1);
            y1=zeros(nch,ndat2);
            y2=zeros(nch,ndat2/2);
            x2=zeros(1,ndat2*2);
            for k = 1:nch
                x1(1:ndat1)=x1(ndat1+1:2*ndat1);
                x1(ndat1+1:2*ndat1)=yy(k,:);
                x0=fft(x1(k,:));
                if hpfr > 0
                    x0(nd3:-1:1)=x0(nd3:-1:1)./((slop3:nd3+slop3-1)/slop3).^slexp;
                end
                x0(nd2*2:(ndat1-nd2)*2+2)=0;
                x0(nd2*2-10:nd2*2-1)=x0(nd2*2-10:nd2*2-1).*(10:-1:1)/10;
                x2(1:nd2*2)=x0(1:nd2*2);
                x2(ndat2*2:-1:(ndat2-nd2)*2+2)=conj(x0(2:nd2*2));
                x2=ifft(x2);
                y1(k,:)=x2(ndat2/2+1:3*ndat2/2);
            end
            
            w_out=ndat2*nch;
            if ic_newstream == 1
                for k = 1:nch
                    y2(k,:)=y1(k,ndat2*nch/2+1:ndat2*nch);
                    y2(k,1:20)=y2(k,1:20).*(0:19)/20;
                end
%                 w_tot=w_tot-nch*ndat2/2;
                w_out=w_out/2;
                fwrite(sds2.fid,y2(:)*rat,'float32');
                ic_newstream=0;
            else  
                fwrite(sds2.fid,y1(:)*rat,'float32');
            end
            p_tot=p_tot+ndat1;
            w_tot=w_tot+w_out;
            w_tot_fil=w_tot_fil+w_out;
            
            rest=rest-w_out;
            if rest <= 0
                fileout1=fileout;
                t2A=t2+(w_tot/nch)*dtout/86400;
                fileout=new_file(file{i},t2A);
                close_sdsfile(sds2.fid,prefilout,fileout,w_tot_fil/nch);
                w_tot_fil=0;
                prefilout=fileout1;
                sds0.t0=t2A;
                sds2=sds_openw([folderout filesep fileout],sds0);
                rest=maxndat*nch;
            end
            r_intot=0;
            ndat1A=ndat1;
            yy=zeros(1,ndat1*nch);
        else
        end
    end
    
    t1next=t1+(dt/86400)*r_tot_fil/nch;
    fclose(sds1.fid);
end

close_sdsfile(sds2.fid,prefilout,'#NOFILE',w_tot_fil/nch);


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