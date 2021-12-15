function psc_reshape_db2(op,dirin,dirout,infr1,infr2)
% PSC_RESHAPE_DB2  type 2 pss candidate files post-processing
%                  High speed
%
%       psc_reshape_db2(op,dirin,dirout,infr1,infr2)
%
%  op           operation:
%                 0 -> sort input files
%                 1 -> to 242 files (first coincidence group) (contains sort)
%                 2 -> to 242 files (second coincidence group) (contains sort)
%
%  dirin         input directory (root)
%  dirout        output directory (root)
%  infr1,infr2   min,max value of frequency groups (def 1 - 200)

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('dirin')
    dirin=selfolder;
    dirin=[dirin dirsep];
end

if ~exist('dirout')
    dirout=selfolder;
    dirout=[dirout dirsep];
end

if ~exist('op')
    op=1;
end

if ~exist('infr1')
    infr1=1;
end

if ~exist('infr2')
    infr2=200;
end

disp(['start at ' datestr(now)])
N=100000;

for i = infr1:infr2
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    file=sprintf('pss_cand_%04d',(i-1)*10);
    filtot=[dirin dir1 dirsep dir2 dirsep file];
    filtotout=[dirout dir1 dirsep dir2 dirsep file];
    filin=[filtot '.cand'];

    fid=fopen(filin,'r+');
    if fid < 0
        disp(['no ' filin]);
        continue;
    end
    candstr=psc_rheader(fid);
    point=ftell(fid);
    
    eofstat=0;
    plurif=0;
    ncand=0;
    icopen=0;
    while eofstat == 0
        N=3000000; % sic
        [cand,nread,eofstat]=psc_readcand(fid,N);
        nn=length(cand)/8;
        ncand=ncand+nn;
        if eofstat == 0
            plurif=1;
        end

        if op == 0
            if eofstat == 0
                disp([filin 'not ordered - too large'])
                break
            end
            cand=reshape(cand,8,nn);
            cand=sortrows(cand.',[2 1]);
            cand=cand.';
            cand=cand(:);

            fseek(fid,point,'bof');
            fwrite(fid,cand,'uint16');
        else
            if op == 2
                if candstr.prot == 1
                    candstr.prot=2;
                end
                if candstr.prot == 3
                    candstr.prot=4;
                end
            end

            dlam=candstr.dlam;
            dbet=candstr.dbet;
            filtotout=[dirout dir1 dirsep dir2 dirsep file];
            if icopen == 0
                fid1=crea_files(candstr,filtotout);
                icopen=1;
            end
            cand=reshape(cand,8,nn);
            cand=sortrows(cand',[2 1]);
            lam=cand(:,3)*dlam;
            bet=cand(:,4)*dbet-90;
            kk=psc_kfiles(lam,bet);plot(sort(kk)),pause(1)

            for k = 1:242
                [kk1,kk2]=find(kk==k);%disp([i size(cand) length(kk2)])
                if length(kk1) > 0
                    cand1=cand(kk1,:);%disp(size(cand1))
                    cand1=cand1.';
                    cand1=cand1(:);
                    fwrite(fid1(k),cand1,'uint16');
                end
            end
        end
    end
    
    disp(sprintf(' --> %s : %d  -  %s',file,ncand,datestr(now)))
    close_files(fid1);
    if plurif == 1
        sort_files(filtotout)
    end
    
    fclose(fid);
end

disp(['stop at ' datestr(now)])


function  fid1=crea_files(header,filtot)

fid1(1:242)=0;

for i = 1:242
    file=sprintf('%s_%03d.cand',filtot,i);
    fid1(i)=fopen(file,'w');
    psc_wheader(fid1(i),header);
end


function close_files(fid1)

for i = 1:242
    fclose(fid1(i));
end


function  sort_files(filtot)

for i = 1:242
    file=sprintf('%s_%03d.cand',filtot,i);
    
    fid=fopen(file,'r+');
    if fid < 0
        disp(['no ' filin]);
    end
    candstr=psc_rheader(fid);
    point=ftell(fid);
    
    [cand,nread,eofstat]=psc_readcand(fid,2000000);
    if eofstat == 0
        disp([' *** ERROR ! too much candidates in the file ' file])
    else
%        disp(sprintf(' %s  %d',file,nread));
    end
    nn=length(cand)/8;
    cand=reshape(cand,8,nn);
    cand=sortrows(cand',[2 1]);
    cand=cand.';
    cand=cand(:);

    point1=ftell(fid);

    fseek(fid,point,'bof');
    fwrite(fid,cand,'uint16');
    fclose(fid);
end