function psc_reshape_single(op,prefilout,filin,dirout)
% PSC_RESHAPE_SINGLE  pss candidate files post-processing (type 2) - single input file
%
%         psc_reshape_single(op,prefilout,filin,dirout   
%
%  op      operation:
%               0 -> sort
%               1 -> to 242 files (first coincidence group)
%               2 -> to 242 files (second coincidence group)
%
%  prefilout    first piece of output file names
%  filin        input file
%
%  If the files are not sorted, firstly sort them !

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('prefilout')
    prefilout='candout_';
end

if ~exist('filin')
    filin=selfile(' ');
end

if ~exist('op')
    op=1;
end

disp(['start at ' datestr(now)])
N=250000;

fid=fopen(filin,'r+');

if fid < 0
    disp(['no ' filin]);
end
candstr=psc_rheader(fid);
point=ftell(fid);

% [cand,nread,eofstat]=psc_readcand(fid,N);
% nn=length(cand)/8;

% if nread == N
%     disp(' *** Probable less candidates read')
% end
    
if op == 0
    eofstat=0;
    ntot=0;
    while eofstat == 0
        [cand,nread,eofstat]=psc_readcand(fid,N);
        ntot=ntot+nread
        nn=length(cand)/8;
        cand=reshape(cand,8,nn);
        cand=sortrows(cand',[1 2]);
        cand=cand';
        cand=cand(:);
        
        point1=ftell(fid);

        fseek(fid,point,'bof');
        fwrite(fid,cand,'uint16');
        fclose(fid);
        fid=fopen(filin,'r+');
        fseek(fid,point1,'bof');
    end
    fclose(fid);
    ntot
    return
end

if ~exist('dirout')
    dirout=selfolder(' ');
    dirout=[dirout dirsep];
end

if op > 0
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
%        filtot=[dirout dir1 dirsep dir2 dirsep file]
    filtot=[dirout prefilout];
    fid1=crea_files(candstr,filtot);
    
    eofstat=0;
    ntot=0;
    while eofstat == 0
        [cand,nread,eofstat]=psc_readcand(fid,N);
        ntot=ntot+nread
        nn=length(cand)/8;
        cand=reshape(cand,8,nn);
        cand=sortrows(cand');
        lam=cand(:,3)*dlam;
        bet=cand(:,4)*dbet-90;
        kk=psc_kfiles(lam,bet);
        [kk0,kkk]=sort(kk);
        kk1=diff(kk0);
        kk2=find(kk1);
        kk2(242)=nn;
        kk2=kk2*8;
        cand1(1:nn,:)=cand(kkk,:);
        cand=cand1';
        cand=cand(:);
        n1=1;

        for k = 1:242
            fwrite(fid1(k),cand(n1:kk2(k)),'uint16');
            n1=kk2(k)+1;
        end
    end

    close_files(fid1);
    
    sort_files(filtot);
end

fclose(fid);

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
        disp(sprintf(' %s  %d',file,nread));
    end
    nn=length(cand)/8;
    cand=reshape(cand,8,nn);
    cand=sortrows(cand',[2 1]);
    cand=cand';
    cand=cand(:);

    point1=ftell(fid);

    fseek(fid,point,'bof');
    fwrite(fid,cand,'uint16');
    fclose(fid);
end