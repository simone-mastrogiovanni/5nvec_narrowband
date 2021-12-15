function psc_coin_1(dircand1,dircand2,searstr,resdir)
%PSC_COIN_1  finds coincidences in psc-db (basic way)
%
%  dircand1     candidate first directory 
%  dircand2     candidate second directory
%  prefil1      pre-filename string first group
%  prefil1      pre-filename string second group
%  searstr      search structure
%  resfile      result file

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(['start coin at ' datestr(now)])
Nmax=10000000;

snag_local_symbols;

if ~exist('searstr')
   def=2;
%     def=20;
    searstr.diffr=def;
    searstr.diflam=def;
    searstr.difbet=def;
    searstr.difsd1=def;
end

nfreq=2000;
diffr=searstr.diffr;
nn=0;

for i = 1:nfreq
    vdir1=floor((i-1)/100);
    vdir2=floor((i-vdir1*100-1)/10);
    vdir3=floor(i-vdir1*100-vdir2*10-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
%     disp([dir1 dirsep dir2 dirsep dir3])
    file=sprintf('pss_cand_%04d.cand',i-1);
    filtot1=[dircand1 dir1 dirsep dir2 dirsep file];
    filtot2=[dircand2 dir1 dirsep dir2 dirsep file];
    fid1=fopen(filtot1);
    fid2=fopen(filtot2);
    
    candstr1=psc_rheader(fid1);
    candstr2=psc_rheader(fid2);
    dfr1=1/(candstr1.st*candstr1.fftlen);
    dfr2=1/(candstr2.st*candstr2.fftlen);
    
    if i == 1
        fid=fopen('pss_cand_report.txt','w');
        fprintf(fid,'       PSS Coincidence report \r\n\r\n');
        str=blank_trim(char(candstr1.capt'));
        fprintf(fid,'  DB 1 -> %s \r\n',str);
        fprintf(fid,'          initim,fftlen  %f   %d \r\n\r\n',candstr1.initim,candstr1.fftlen);
        
        str=blank_trim(char(candstr2.capt'));
        fprintf(fid,'  DB 2 -> %s \r\n',str);
        fprintf(fid,'          initim,fftlen  %f   %d \r\n\r\n',candstr2.initim,candstr2.fftlen);
    end
    
    if floor(i/10)*10 == 1
        i
    end
    
    [cand1,nread1]=psc_readcand(fid1,Nmax);
    [cand2,nread2]=psc_readcand(fid2,Nmax);
    fr1=psc_readfr(cand1);
    fr2=psc_readfr(cand2);
    
    dif=diffr*(dfr1+dfr2);
    dil=searstr.diflam*(candstr1.dlam+candstr2.dlam);
    dib=searstr.difbet*(candstr1.dbet+candstr2.dbet);
    dis=searstr.difsd1*(candstr1.dsd1+candstr2.dsd1);
    
    m1=1;
    
    for ii = 1:nread1
        ic=0;
        for jj =m1:nread2
            if abs(fr1(ii)-fr2(jj)) < dif
                ic=1;
            else
                if ic == 1
                    iii=(ii-1)*8;
                    jjj=(jj-1)*8;
                    lam1=cand1(iii+3)*candstr1.dlam;
                    bet1=cand1(iii+4)*candstr1.dbet-90;
                    sd1_1=cand1(iii+5)*candstr1.dsd1;
                    lam2=cand2(jjj+3)*candstr2.dlam;
                    bet2=cand2(jjj+4)*candstr2.dbet-90;
                    sd1_2=cand2(jjj+5)*candstr2.dsd1;
                    
                    if mod(lam1-lam2,360) < dil
                        if abs(bet1-bet2) < dib
                            if abs(sd1_1-sd1_2) < dis
                                cr1=cand1(iii+6)*candstr1.dcr;
                                mh1=cand1(iii+7)*candstr1.dmh;
                                h1=cand1(iii+8)*candstr1.dh;
                                cr2=cand2(jjj+8)*candstr2.dcr;
                                mh2=cand1(jjj+7)*candstr2.dmh;
                                h2=cand2(jjj+8)*candstr2.dh;
                                nn=nn+1;
                                fprintf(fid,' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e   %f <-> %f   %f <-> %f   %e <-> %e \r\n',...
                                    nn,fr1(ii),fr2(jj),lam1,lam2,bet1,bet2,sd1_1,sd1_2,cr1,cr2,mh1,mh2,h1,h2);
                                break
                            end
                        end
                    end
                else
                    m1=jj;
                    break
                end
            end
        end
    end

    fclose(fid1);
    fclose(fid2);
end

fclose(fid);
disp(['stop coin at ' datestr(now)])