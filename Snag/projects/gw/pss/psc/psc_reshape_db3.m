function psc_reshape_db3(dirin,dirout,infr1,infr2)
% PSC_RESHAPE_DB3  type 3 pss candidate files post-processing
%
%       psc_reshape_db3(op,dirin,dirout,infr1,infr2)
%
%  dirin         input directory (root)
%  dirout        output directory (root)
%  infr1,infr2   min,max value of frequency groups (def 1 - 200)

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('dirin','var')
    dirin=selfolder;
    dirin=[dirin dirsep];
end

if ~exist('dirout','var')
    dirout=selfolder;
    dirout=[dirout dirsep];
end

if ~exist('infr1','var')
    infr1=1;
end

if ~exist('infr2','var')
    infr2=200;
end

disp(['start at ' datestr(now)])

for i = infr1:infr2
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
%     vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    file=sprintf('pss_cand_%04d',(i-1)*10);
    filtot=[dirin dir1 dirsep dir2 dirsep file];
    filin=[filtot '.cand'];

    fid=fopen(filin,'r+');
    if fid < 0
        disp(['no ' filin]);
        continue;
    end
    candstr=psc_rheader(fid);
    
    eofstat=0;
    ncand=0;
    icopen=0;

    while eofstat == 0
        N=3000000; % sic
        [cand,nread,eofstat]=psc_readcand(fid,N);
        nn=length(cand)/8;
        ncand=ncand+nn;

        filtot=[dirout dir1 dirsep dir2 dirsep file];
        cand=reshape(cand,8,nn);
        kk=cand(5,:); % plot(sort(kk)), pause(1)
        k1=min(kk);
        if k1 > 0
            k1=0;
        end
        k2=candstr.nsd1-1;
        
        if icopen == 0
            fid1=crea_files(candstr,filtot,k1,k2);
            icopen=1;
        end

        for k = k1:k2
            [kk1,kk2]=find(kk==k);disp([k size(cand) length(kk2)])
            if length(kk1) > 0
%                 cand1=cand(kk1,:);
%                 cand1=cand1';
                cand1=cand(:,kk1);
                cand1=cand1(:);
                fwrite(fid1(k-k1+1),cand1,'uint16');
            end
        end
    end
    
    disp(sprintf(' --> %s : %d  -  %s',file,ncand,datestr(now)))
    close_files(fid1,k1,k2);
%     if plurif == 1
%         sort_files(filtot)
%     end
    
    fclose(fid);
end

disp(['stop at ' datestr(now)])


function  fid1=crea_files(header,filtot,k1,k2)

fid1(1:k2-k1+1)=0;

for i = k1:k2
    file=sprintf('%s_sd%04d.cand',filtot,i);
    fid1(i-k1+1)=fopen(file,'w');
    psc_wheader(fid1(i-k1+1),header);
end


function close_files(fid1,k1,k2)

for i = k1:k2
    fclose(fid1(i-k1+1));
end


% function  sort_files(filtot)
% 
% for i = 1:242
%     file=sprintf('%s_%03d.cand',filtot,i);
%     
%     fid=fopen(file,'r+');
%     if fid < 0
%         disp(['no ' filin]);
%     end
%     candstr=psc_rheader(fid);
%     point=ftell(fid);
%     
%     [cand,nread,eofstat]=psc_readcand(fid,2000000);
%     if eofstat == 0
%         disp([' *** ERROR ! too much candidates in the file ' file])
%     else
% %        disp(sprintf(' %s  %d',file,nread));
%     end
%     nn=length(cand)/8;
%     cand=reshape(cand,8,nn);
%     cand=sortrows(cand',[2 1]);
%     cand=cand';
%     cand=cand(:);
% 
%     point1=ftell(fid);
% 
%     fseek(fid,point,'bof');
%     fwrite(fid,cand,'uint16');
%     fclose(fid);
% end