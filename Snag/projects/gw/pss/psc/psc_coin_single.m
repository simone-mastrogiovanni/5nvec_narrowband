function [c_cand1,c_cand2]=psc_coin_single(dircand1,dircand2,searstr,resfile)
%PSC_COIN_SINGLE  finds coincidences in psc-db (type 2)
%                 from a single file db
%
%   psc_coin_single(dircand1,dircand2,searstr,resfile)
%
%  dircand1     candidate first directory (with beginning of files, e.g.
%                  "K:\pss\virgo\cand\test_0456\c7\c7_cand_\")
%  dircand2     candidate second directory (with beginning of files, e.g.
%                  "K:\pss\virgo\cand\test_0456\c6\c6-2_cand_\")
%  searstr      search structure
%  resfile      result file
%
% type-2 psc-db is in files of 10 Hz, each group in 242 sky patches

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

start=datestr(now);
disp(['start coin at ' start])

snag_local_symbols;

if ~exist('searstr') || ~isfield(searstr,'diffr')
    def=2.001; % Attention ! the differences are discrete !
    searstr.diffr=1.;
    searstr.diflam=def;
    searstr.difbet=def;
    searstr.difsd1=.25;
end

if ~exist('resfile')
    resfile='psc_coin_report.coin';
end

N1=0;
N2=0;
N1N2=0;
ncoin=0;
nnn=0;ncf=0;ncs=0;ncb=0;
nfreq=1;

searstr.minfr1=1.e36;
searstr.minlam1=1.e36;
searstr.minbet1=1.e36;
searstr.minsd11=1.e36;
searstr.maxfr1=-1.e36;
searstr.maxlam1=-1.e36;
searstr.maxbet1=-1.e36;
searstr.maxsd11=-1.e36;
searstr.minfr2=1.e36;
searstr.minlam2=1.e36;
searstr.minbet2=1.e36;
searstr.minsd12=1.e36;
searstr.maxfr2=-1.e36;
searstr.maxlam2=-1.e36;
searstr.maxbet2=-1.e36;
searstr.maxsd12=-1.e36;
c_cand1=0;
c_cand2=0;
prcand=0;

for k = 1:242
    file=sprintf('_%03d.cand',k);
    filtot1=[dircand1 file]; disp(filtot1)
    filtot2=[dircand2 file];
    dir1=dir(filtot1);
    dir2=dir(filtot2);

    fid1=fopen(filtot1);
    fid2=fopen(filtot2);

    candstr1=psc_rheader(fid1);
    candstr2=psc_rheader(fid2);
    
    i188=188;
    if candstr1.prot > 2
        i188=256;
    end
    len1=floor((dir1.bytes-i188)/16);
    i188=188;
    if candstr2.prot > 2
        i188=256;
    end
    len2=floor((dir2.bytes-i188)/16);
    dfr1=1/(candstr1.st*candstr1.fftlen);
    dfr2=1/(candstr2.st*candstr2.fftlen);

    [cand1,nread1]=psc_readcand(fid1,len1);
    [cand2,nread2]=psc_readcand(fid2,len2);
    N1=N1+nread1;
    N2=N2+nread2;
    N1N2=N1N2+nread1*nread2;
    fr1=psc_readfr(cand1);
    fr2=psc_readfr(cand2);
    
    %% DA TOGLIERE INIZIO
%     [fr1,ib]=sort(fr1); max(diff(ib))
%     [fr2,ib]=sort(fr2); max(diff(ib))
    %% DA TOGLIERE FINE
    
    prcand=prcand+nread1*nread2;
    
    searstr.minfr1=min(searstr.minfr1,min(fr1));
    searstr.minfr2=min(searstr.minfr2,min(fr2));
    searstr.maxfr1=max(searstr.maxfr1,max(fr1));
    searstr.maxfr2=max(searstr.maxfr2,max(fr2));
    
    candstat=psc_candstat(cand1,candstr1,0);
    searstr.minlam1=min(searstr.minlam1,candstat.min(1));
    searstr.minbet1=min(searstr.minbet1,candstat.min(2));
    searstr.minsd11=min(searstr.minsd11,candstat.min(3));
    searstr.maxlam1=max(searstr.maxlam1,candstat.max(1));
    searstr.maxbet1=max(searstr.maxbet1,candstat.max(2));
    searstr.maxsd11=max(searstr.maxsd11,candstat.max(3));
    
    candstat=psc_candstat(cand2,candstr2,0);
    searstr.minlam2=min(searstr.minlam2,candstat.min(1));
    searstr.minbet2=min(searstr.minbet2,candstat.min(2));
    searstr.minsd12=min(searstr.minsd12,candstat.min(3));
    searstr.maxlam2=max(searstr.maxlam2,candstat.max(1));
    searstr.maxbet2=max(searstr.maxbet2,candstat.max(2));
    searstr.maxsd12=max(searstr.maxsd12,candstat.max(3));

    dif=searstr.diffr*(dfr1+dfr2)/2;
    dil=searstr.diflam*(candstr1.dlam+candstr2.dlam)/2;
    dib=searstr.difbet*(candstr1.dbet+candstr2.dbet)/2;
    dis=searstr.difsd1*(candstr1.dsd1+candstr2.dsd1)/2;

    m1=1;
    ic=0;

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
            sd1_2=cand2(jjj+5)*candstr2.dsd1;

            if abs(sd1_1-sd1_2) <= dis  
                ncs=ncs+1;
                bet1=cand1(iii+4)*candstr1.dbet-90;
                bet2=cand2(jjj+4)*candstr2.dbet-90;
                if abs(bet1-bet2) <= dib
                    ncb=ncb+1;
                    lam1=cand1(iii+3)*candstr1.dlam;
                    lam2=cand2(jjj+3)*candstr2.dlam;
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
                        c_cand2(5,ncoin)=cand2(jjj+6)*candstr2.dcr;
                        c_cand2(6,ncoin)=cand2(jjj+7)*candstr2.dmh;
                        c_cand2(7,ncoin)=cand2(jjj+8)*candstr2.dh;

%                         fprintf(fid,' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e   %f <-> %f   %f <-> %f   %e <-> %e \r\n',...
%                             ncoin,fr1(ii),fr2(jj),lam1,lam2,bet1,bet2,sd1_1,sd1_2,cr1,cr2,mh1,mh2,h1,h2);
                    end
                end;
            end
        end
    end

    fclose(fid1);
    fclose(fid2);
end

searstr.N1=N1;
searstr.N2=N2;
searstr.N1N2=N1N2;
searstr.ncoin=ncoin;
searstr.nnn=nnn;
searstr.ncf=ncf;
searstr.ncs=ncs;
searstr.ncb=ncb;

prcand=prcand/(N1*N2)

%nnn,ncf,ncs,ncb,ncoin
% fprintf(fid,'\r\n   Coincidences between %d and %d candidates.\r\n',N1,N2);
% fprintf(fid,'\r\n   %d comparisons, %d after frequency, %d after spin-down, %d after beta, %d after lambda.\r\n',nnn,ncf,ncs,ncb,ncoin);
stop=datestr(now);
% fprintf(fid,'\r\n Coincidence work started at %s -> stopped at %s',start,stop);

% fclose(fid);

psc_coinrep_single(resfile,candstr1,candstr2,searstr,c_cand1,c_cand2,start,stop);

disp(['stop coin at ' stop])