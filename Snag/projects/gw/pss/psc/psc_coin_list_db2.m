function [c_cand1,c_cand2]=psc_coin_list_db2(dircand1,listcand,freq,searstr,resfile)
%PSC_COIN  finds coincidences in psc-db (type 2)
%
%   [c_cand1,c_cand2]=psc_coin_list_db2(dircand1,listcand,freq,searstr,resfile)
%
%  dircand1     candidate first directory (with last \)
%  listcand     list candidate matrix
%  freq         [min max] frequencies; 0 all; 
%               [fr1, fr2, ...., frn] if n > 2 frx multiple of 10 Hz (start)
%  searstr      search structure
%  resfile      result file
%
% type-2 psc-db is in files of 10 Hz, each group in 242 sky patches

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

searstr.verb=2;
c_cand1=0;
c_cand2=0;
start=datestr(now);
disp(['start coin at ' start])

[a ix]=sort(listcand(1,:));
listcand=listcand(:,ix);

if ~exist('freq','var')
    freq=0;
end
if length(freq) == 1
    if freq == 0
        freq=[0 2000];
    else
        freq=[freq freq];
    end
end
if length(freq) == 2
    nfreq1=ceil((freq(1)+0.00001)/10);
    nfreq2=floor((freq(2)+0.00001)/10);
    if nfreq2 < nfreq1
        nfreq2=nfreq1;
    end
    nfreq=nfreq1:nfreq2;
else
    nfreq=round(freq/10)+1;
end

snag_local_symbols;

def=1000.001; % Attention ! the differences are discrete !

if ~exist('searstr','var') || ~isfield(searstr,'diffr')
    searstr.diffr=2;
    searstr.diflam=def;
    searstr.difbet=def;
    searstr.difsd1=1*0;
end

if ~exist('resfile','var')
    resfile='psc_coin_report';
    resfile=[resfile '_' datestr(now,30) '.coin'];
end

fid=fopen(resfile,'w');
fprintf(fid,'         PSS Coincidence report \r\n\r\n');
fprintf(fid,'         level 1 coincidences  \r\n');
fprintf(fid,'    candidate folder 1 %s \r\n',dircand1);
fprintf(fid,'    candidate list 2 %s \r\n',inputname(2));
fprintf(fid,'           Total Band %f - %f  \r\n',freq(1),freq(length(freq)));
fprintf(fid,'         norm.width %f  %f  %f  %f \r\n\r\n',...
    searstr.diffr,searstr.diflam,searstr.difbet,searstr.difsd1);

N1=0;
N2=0;
N1N2=0;
N10=0;
N20=0;
ncoin=0;
ncointeor=0;
nnn=0;ncf=0;ncs=0;ncb=0;
ncoin0=0;
fidop=0;
nsdmin10=1.e10;
nsdmax10=-1.e10;
nsdmin20=1.e10;
nsdmax20=-1.e10;

for i = nfreq
    fidadd=0;
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    fre1=vdir1*100+vdir2*10;
    fre2=fre1+10;
    fr=listcand(1,:);
    [i1 i2]=find(fr>=fre1*0.999&fr<=fre2*1.001); %fr(i2)
    nread2=length(i2);
    if nread2 <= 0
        continue
    end
    cand2=listcand(:,i2);
    N2=N2+nread2;
    
    fildir1=[dircand1 dir1 dirsep dir2 dirsep];
    
%     file=sprintf('pss_cand_%04d.cand',i-1);
%     filtot1=[dircand1 dir1 dirsep dir2 dirsep file];
%     filtot2=[dircand2 dir1 dirsep dir2 dirsep file];

    for k = 1:242
        file=sprintf('pss_cand_%04d_%03d.cand',(i-1)*10,k);
        filtot1=[fildir1 file]; %disp(filtot1)
        dir1=dir(filtot1);
        if length(dir1) == 0
            continue
        end

        fid1=fopen(filtot1);

        candstr1=psc_rheader(fid1);
        
        i188=188;
        if candstr1.prot > 2
            i188=256;
        end
        len1=floor((dir1.bytes-i188)/16);
        if len1 <= 0 
            continue
        end
        
        dfr1=1/(candstr1.st*candstr1.fftlen);
        dfr2=dfr1; % fake
        
        [cand1,nread1]=psc_readcand(fid1,len1);
        N1=N1+nread1;
        [fr1,nsdmin1,nsdmax1]=psc_readfr(cand1); 
        %out=check_sort(fr1)
        fr2=cand2(1,:);
        nsdmin2=nsdmin1; % fake
        nsdmax2=nsdmax1; % fake
        nsdmin10=min(nsdmin10,nsdmin1);
        nsdmax10=max(nsdmax10,nsdmax1);
        nsdmin20=min(nsdmin20,nsdmin2);
        nsdmax20=max(nsdmax20,nsdmax2);
        nsd1=nsdmax10-nsdmin10+1; % incorrect !
        nsd2=nsdmax20-nsdmin20+1; % incorrect !
        
        if fidadd == 0
            if fidop == 0
                fprintf(fid,'          initim,fftlen  %f   %d \r\n',...
                    candstr1.initim,candstr1.fftlen);
                fidop=1;
            end
            fidadd=1;
            nfr1=10/dfr1;
            nlam1=round(360/candstr1.dlam);
            nbet1=round(180/candstr1.dbet);
            nfr2=nfr1; % fake
            nlam2=nlam1;
            nbet2=nbet1;
            fprintf(fid,'\r\n ----------  Band %d - %d  ---------\r\n\r\n',(i-1)*10,i*10);
            str=blank_trim(char(candstr1.capt'));
            fprintf(fid,'  DB 1 -> %s \r\n',str);
            fprintf(fid,'          d-fr,lam,bet,sd1,cr,mh,h   %f   %f   %f   %e   %f   %f   %e \r\n',...
                dfr1,candstr1.dlam,candstr1.dbet,candstr1.dsd1,candstr1.dcr,candstr1.dmh,candstr1.dh);
            fprintf(fid,'          n-fr,lam,bet,sd1   %d   %d   %d   %d \r\n\r\n',...
                nfr1,nlam1,nbet1,nsd1);
        end

        dif=searstr.diffr*(dfr1+dfr2)/2;
        dil=searstr.diflam*(candstr1.dlam+candstr1.dlam)/2; % fake
        dib=searstr.difbet*(candstr1.dbet+candstr1.dbet)/2;
        dis=searstr.difsd1*(candstr1.dsd1+candstr1.dsd1)/2;

        m1=1;
        ic=0; % nread2,size(fr2)

        for ii = 1:nread1
            iii=(ii-1)*8;
            for jj =m1:nread2
                jjj=(jj-1)*8;
                aa=fr1(ii)-fr2(jj);
                nnn=nnn+1;
                if aa > dif
                    m1=jj;
                    continue
                end
                if aa < -dif
                    break
                end

                ncf=ncf+1;

                sd1_1=cand1(iii+5)*candstr1.dsd1;
                sd1_2=cand2(4,jj);

                if abs(sd1_1-sd1_2) <= dis  
                    ncs=ncs+1;
                    bet1=cand1(iii+4)*candstr1.dbet-90;
                    bet2=cand2(3,jj);
                    if abs(bet1-bet2) <= dib
                        ncb=ncb+1;
                        lam1=cand1(iii+3)*candstr1.dlam;
                        lam2=cand2(2,jj);
                        llam=abs(lam1-lam2);
                        if llam > 300
                            llam=360-llam;
                        end
                        if llam <= dil
                            ncoin=ncoin+1;%ncoin
                            c_cand1(1,ncoin)=fr1(ii);
                            c_cand2(1,ncoin)=fr2(jj);
                            c_cand1(2,ncoin)=lam1;
                            c_cand2(2,ncoin)=lam2;
                            c_cand1(3,ncoin)=bet1;
                            c_cand2(3,ncoin)=bet2;
                            c_cand1(4,ncoin)=sd1_1;
                            c_cand2(4,ncoin)=sd1_2;
                            c_cand1(5,ncoin)=0;
                            c_cand1(6,ncoin)=0;
                            c_cand1(7,ncoin)=0;
                            c_cand2(5,ncoin)=0;
                            c_cand2(6,ncoin)=0;
                            c_cand2(7,ncoin)=0;
                            c_cand1(5,ncoin)=cand1(iii+6)*candstr1.dcr;
                            c_cand1(6,ncoin)=cand1(iii+7)*candstr1.dmh;
                            c_cand1(7,ncoin)=cand1(iii+8)*candstr1.dh;
                            c_cand2(5,ncoin)=cand2(5,jj);
                            c_cand2(6,ncoin)=cand2(6,jj);
                            c_cand2(7,ncoin)=cand2(7,jj);

                            if searstr.verb == 2
                                fprintf(fid,' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e  \r\n',...
                                    ncoin,fr1(ii),fr2(jj),lam1,lam2,bet1,bet2,sd1_1,sd1_2);
                            end
                            if searstr.verb == 1
                                disp(sprintf(' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e',...
                                    ncoin,fr1(ii),fr2(jj),lam1,lam2,bet1,bet2,sd1_1,sd1_2));
                            end
                        end
                    end
                end
            end
        end
        
        fclose(fid1);
    end
%     if fidop > 0
%         fprintf(fid,'   Number of coincidences in the band -> %d  (%.2f)\r\n\r\n',ncoin-ncoin0,ncoint);
%     end
    
    if N1 > 0
        wf1=(1+2*searstr.diffr)*dfr1/10;
        wl1=(1+2*searstr.diflam)*candstr1.dlam/360;
        wb1=(1+2*searstr.difbet)*candstr1.dbet/180;
        nsd1=nsdmax10-nsdmin10+1;
        if candstr1.nsd1 > 0
            nsd1=candstr1.nsd1;
        end
        nsd2=nsdmax20-nsdmin20+1;
        ws1=(1+2*searstr.difsd1)/nsd1;

        ncoint=(N2-N20)*(1-exp(-wf1*(N1-N10)*wl1*wb1*ws1));
        ncointeor=ncointeor+ncoint;
        
        fprintf(fid,'   Number of coincidences in the band -> %d  (%.2f)\r\n\r\n',ncoin-ncoin0,ncoint);
        str=sprintf('Band %d - %d %s -> D1,D2,cointeor,coin,tot : %d %d %.2f %d %d',(i-1)*10,i*10,datestr(now),N1-N10,N2-N20,ncoint,ncoin-ncoin0,ncoin);
        disp(str);
        fprintf(fid,'%s \r\n',str);
        fprintf(fid,'    wf1,wl1,wb1,ws1: %f  %f  %f  %f  \r\n',wf1,wl1,wb1,ws1);
    end
    N10=N1;
    N20=N2;
    ncoin0=ncoin;
end

nnn,ncf,ncs,ncb,ncointeor,ncoin

fprintf(fid,'\r\n   Coincidences between %d and %d candidates.\r\n',N1,N2);
fprintf(fid,'     theoretical %.2f  found %d \r\n',ncointeor,ncoin);
fprintf(fid,'\r\n   %d comparisons, %d after frequency, %d after spin-down, %d after beta, %d after lambda.\r\n',nnn,ncf,ncs,ncb,ncoin);
stop=datestr(now);
fprintf(fid,'\r\n Coincidence work started at %s -> stopped at %s',start,stop);

fclose(fid);
disp(['stop coin at ' stop])


function out=check_sort(vec)
out=0;
[vec,ix]=sort(vec);
ix=diff(ix);
out=max(ix)-1;