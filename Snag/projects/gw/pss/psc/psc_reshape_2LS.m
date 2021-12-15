function psc_reshape_2LS(op,dirin,dirout)
% PSC_RESHAPE_2  pss candidate files post-processing
%                (Low speed)
%
%  op      operation:
%               0 -> sort
%               1 -> to 242 files (first coincidence group)
%               2 -> to 242 files (second coincidence group)
%
%  dirin   input directory (root)
%
%  If the files are not sorted, firstly sort them !

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

DISP(' *** ERROR ! sistemare per 8 I16 ! (da riga 59)')
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

disp(['start at ' datestr(now)])
nfreq=200;%nfreq=2
N=2000000;

for i = 1:nfreq
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
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
    point=ftell(fid);
    
    [cand,nread,eofstat]=psc_readcand(fid,N);
    nn=length(cand)/7;
    
    if op == 0
        cand=reshape(cand,7,nn);
        cand=sortrows(cand.');
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
        iii=1:7:nn*7;
        dlam=candstr.dlam;
        dbet=candstr.dbet;
        filtot=[dirout dir1 dirsep dir2 dirsep file];
        fid1=crea_files(candstr,filtot);
        lam=cand(iii+1)*dlam;
        bet=cand(iii+2)*dbet-90;
        kk=psc_kfiles(lam,bet);
        for ii = 0:nn-1
            ii7=ii*7+1;
            fwrite(fid1(kk(ii+1)),cand(ii7:ii7+6),'uint16');
        end
        
        close_files(fid1);
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
    