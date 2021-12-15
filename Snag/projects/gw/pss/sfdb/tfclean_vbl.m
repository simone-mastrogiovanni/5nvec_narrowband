function tfclean_vbl(filelist,folderout,vetocell,win)
% time-frequency cleaning of a peak map 
%
%   tfclean_vbl(filelist,folderout,veto,win)
%
%   filelist    file list file (in folder)
%   folderout   output folder (with dir sep \ or /)
%   veto        (n 3) [t f amp] vetoed (sorted by t)
%   win         veto window (for frequency, typically 1.5 dfr; def [0.5 0.015])
%
%   Cleaning procedure:
%   - create the peakmap file list with e.g.:  dir *.vbl /s/b > list_VSR2_pm.txt
%     and edit to eliminate blank lines etc.
%   - edit and execute ana_peakmap_basic.m: this creates the PMC files (peakmap maps).
%     This should be done for 5~8 sub-bands each time
%   - create the PMH files list
%   - edit and execute ana_PMH, fixing the threshold thresh: this creates
%     the veto array and the vetocell cell array
%   - apply tfclean_vbl

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

if ~exist('win','var')
    win=[0.5 0.015];
end
dt=win(1)/2;
df=win(2)/2;
fidlist=fopen(filelist,'r');
nfiles=0;

ictyp=3;

nfiles=0;

ch.dy=0;
ch.inix=0;
ch.iniy=0;
ch.lenx=0;
ch.leny=0;
ch.type=0;
ch.point=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});disp(str)
    [pathstr, name, ext]= fileparts(file{nfiles});
    filout=[folderout name '_cl' ext];

    vbl_=vbl_open(file{nfiles});
    VBL_=vbl_openw(filout,vbl_);

    if nfiles == 1
        if vbl_.nch == 6
            disp('Type 3 peakmap file')
            ich=4;
            dfr=vbl_.ch(ich).dx;
            lfft=vbl_.ch(ich).lenx*2;
            ictyp=3;
        else
            disp('*** Attention ! not type 3 vbl file')
        end
    end

    nfft=vbl_.len;
    blpoint=zeros(1,nfft);
    vbl_.nextblock=0;
    len=vbl_.len;
    if len == 0
        disp('*** No length - cut at 1000')
        len=1000;
    end
    kbl=0;
    blp=vbl_.point0;

    while vbl_.eof == 0
        kbl=kbl+1;
        blpoint(kbl)=blp;
        if kbl > len
            break
        end
        vbl_=vbl_nextbl(vbl_); % r bloc
        if vbl_.eof > 0
            break
        end
%         npeak=vbl_.ch(4).lenx;
%         splen=vbl_.ch(2).lenx;
%         
%         if(npeak>0)
%             blocklength=32+60*6+6*8+(splen*2)*4+npeak*(4+4+4);
%         else
%             blocklength=32+60*6+6*8+(splen*2)*4+1*(4+4+4);
%         end
%         nextblock=blp+blocklength;
        nextblock=vbl_.nextblock;
        vbl_headblw(VBL_.fid,kbl,vbl_.bltime,nextblock)

        kch=vbl_.block;
        tim=vbl_.bltime;

        vbl_=vbl_headchr(vbl_); % r 1
        vp=fread(vbl_.fid,vbl_.ch(1).lenx,'double'); % p09 % r 
        chp=ftell(VBL_.fid);
        chpoint=chp+60+6*8;
        ch.numb=1;
        ch.lenx=length(vp);
        ch.inix=0;
        ch.dx=0;
        ch.type=6;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,vp,'double'); % w 1

        vbl_=vbl_nextch(vbl_); % r 2
        lensp=vbl_.ch0.lenx;
        inisp=vbl_.ch0.inix;
        dfsp=vbl_.ch0.dx;
        sp=fread(vbl_.fid,lensp,'float32'); % r  
        
        chpoint=chpoint+60+lensp*4;
        ch.numb=2;
        ch.lenx=lensp;
        ch.inix=vbl_.ch(2).inix;
        ch.dx=vbl_.ch(2).dx;
        ch.type=4;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,sp,'float32'); % w 2
        
        vbl_=vbl_nextch(vbl_); % r 3
        ind=fread(vbl_.fid,lensp,'int32'); % r 
        chpoint=chpoint+60+lensp*4;
        ch.numb=3;
        ch.type=3;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,ind,'int32'); % w 3

        vbl_=vbl_nextch(vbl_); % r 4
        npeak=vbl_.ch0.lenx;
        bin=fread(vbl_.fid,npeak,'int32'); % r 
        
 %%%%%%%%%%%%%%%%%
        
        cont=vetocell{1};
        frb=(bin-1)*cont.dfr;
        tmap=vetocell{2};
        ntmap=length(tmap);
        ii=1;
        
        for i = ii:ntmap
            if tim >= tmap(i)+win(1)
                ii=i+1;
                continue
            end
%             tim,i,tmap(i)
            if tim >= tmap(i)-win(1) && tim <= tmap(i)+win(1)
                a=vetocell{i+2};
                for j = 1:length(a);
                    ib=find(frb >= a(j)-win(2) & frb <= a(j)+win(2)); % ib
                    bin(ib)=-abs(bin(ib));
                end
            end
        end
        
 %%%%%%%%%%%%%%%%%
        
        if npeak >0
            chpoint=chpoint+60+npeak*4;
        else
           chpoint=chpoint+60+1*4; 
        end
        ch.numb=4;
        ch.lenx=length(bin);
        ch.inix=vbl_.ch(4).inix;
        ch.dx=vbl_.ch(4).dx;
        ch.type=3;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,bin,'int32'); % w 4
        
        vbl_=vbl_nextch(vbl_); % r 5
        amp=fread(vbl_.fid,npeak,'float32'); % r 

        if npeak >0
            chpoint=chpoint+60+npeak*4;
        else
           chpoint=chpoint+60+1*4; 
        end
        ch.numb=5;
        ch.lenx=length(amp);
        ch.inix=0;
        ch.type=4;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,amp,'float32'); % w 5
        
        vbl_=vbl_nextch(vbl_); % r 6
        pmean=fread(vbl_.fid,npeak,'float32'); % r 

        
        chpoint=0;
        ch.numb=6;
        ch.lenx=length(pmean);
        ch.inix=0;
        ch.type=4;
        vbl_headchw(VBL_.fid,ch,chpoint); % w vbl
        fwrite(VBL_.fid,pmean,'float32'); % w 6
        
        if(npeak>0)
            blocklength=32+60*6+6*8+(lensp*2)*4+npeak*(4+4+4);
        else
            blocklength=32+60*6+6*8+(lensp*2)*4+1*(4+4+4);
        end
        blp=blp+blocklength;
    end
     fclose(vbl_.fid);
     vbl_closew(VBL_,blpoint,nfft);
end
