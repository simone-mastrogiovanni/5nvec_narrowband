function psc_coin(dircand1,dircand2,searstr,resdir)
%PSC_COIN  finds coincidences in psc-db (type 2)
%
%  dircand1     candidate first directory 
%  dircand2     candidate second directory
%  searstr      search structure
%  resfile      result file
%
% type-2 psc-db is in files of 10 Hz, each group in 242 sky patches

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(['start coin at ' datestr(now)])
Nmax=1000000;
N1=0;
N2=0;

snag_local_symbols;

if ~exist('searstr')
    def=2.001;
%     def=20;
    searstr.diffr=def;
    searstr.diflam=def;
    searstr.difbet=def;
    searstr.difsd1=def;
end

nfreq=200;  %nfreq=2;
diffr=searstr.diffr;
ncoin=0;

for i = 1:nfreq
    if floor(i/10)*10 == i
        i
    end
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    fildir1=[dircand1 dir1 dirsep dir2 dirsep];
    fildir2=[dircand2 dir1 dirsep dir2 dirsep];
    
%     file=sprintf('pss_cand_%04d.cand',i-1);
%     filtot1=[dircand1 dir1 dirsep dir2 dirsep file];
%     filtot2=[dircand2 dir1 dirsep dir2 dirsep file];

    for k = 1:242
        file=sprintf('pss_cand_%04d_%03d.cand',(i-1)*10,k);
        filtot1=[fildir1 file];
        filtot2=[fildir2 file];

        fid1=fopen(filtot1);
        fid2=fopen(filtot2);

        candstr1=psc_rheader(fid1);
        candstr2=psc_rheader(fid2);
        dfr1=1/(candstr1.st*candstr1.fftlen);
        dfr2=1/(candstr2.st*candstr2.fftlen);
    
        if i == 1 & k == 1
            nfr1=nfreq*10/dfr1;
            nlam1=round(360/candstr1.dlam);
            nbet1=round(180/candstr1.dbet);
            nsd11=100;
            nfr2=nfreq*10/dfr2;
            nlam2=round(360/candstr2.dlam);
            nbet2=round(180/candstr2.dbet);
            nsd12=100;
            fid=fopen('psc_coin_report.coin','w');
            fprintf(fid,'         PSS Coincidence report \r\n\r\n');
            fprintf(fid,'         level 2 coincidences  \r\n');
            fprintf(fid,'         norm.width %f  %f  %f  %f \r\n\r\n',...
                searstr.diffr,searstr.diflam,searstr.difbet,searstr.difsd1);
            str=blank_trim(char(candstr1.capt'));
            fprintf(fid,'  DB 1 -> %s \r\n',str);
            fprintf(fid,'          initim,fftlen  %f   %d \r\n',candstr1.initim,candstr1.fftlen);
            fprintf(fid,'          d-fr,lam,bet,sd1,cr,mh,h   %f   %f   %f   %e   %f   %f   %e \r\n',...
                dfr1,candstr1.dlam,candstr1.dbet,candstr1.dsd1,candstr1.dcr,candstr1.dmh,candstr1.dh);
            fprintf(fid,'          n-fr,lam,bet,sd1   %d   %d   %d   %d \r\n\r\n',...
                nfr1,nlam1,nbet1,nsd11);

            str=blank_trim(char(candstr2.capt'));
            fprintf(fid,'  DB 2 -> %s \r\n',str);
            fprintf(fid,'          initim,fftlen  %f   %d \r\n\r\n',candstr2.initim,candstr2.fftlen);
            fprintf(fid,'          d-fr,lam,bet,sd1,cr,mh,h   %f   %f   %f   %e   %f   %f   %e \r\n',...
                dfr2,candstr2.dlam,candstr2.dbet,candstr2.dsd1,candstr2.dcr,candstr2.dmh,candstr2.dh);
            fprintf(fid,'          n-fr,lam,bet,sd1   %d   %d   %d   %d \r\n\r\n',...
                nfr2,nlam2,nbet2,nsd12);
        end
    
        [cand1,nread1]=psc_readcand(fid1,Nmax);
        [cand2,nread2]=psc_readcand(fid2,Nmax);
        N1=N1+nread1;
        N2=N2+nread2;
        fr1=(cand1(1:7:length(cand1))+candstr1.inifr)*dfr1;
        fr2=(cand2(1:7:length(cand2))+candstr2.inifr)*dfr2;%disp([Nmax/1000000,k,fr1(nread1-20),fr2(nread2-20)])

        dif=diffr*(dfr1+dfr2);
        dil=searstr.diflam*(candstr1.dlam+candstr2.dlam);
        dib=searstr.difbet*(candstr1.dbet+candstr2.dbet);
        dis=searstr.difsd1*(candstr1.dsd1+candstr2.dsd1);

        m1=1;
        ic=0;

        for ii = 1:nread1
            for jj =m1:nread2
                if abs(fr1(ii)-fr2(jj)) < dif
                    ic=1;
                else
                    if ic == 1
                        iii=(ii-1)*6;
                        jjj=(jj-1)*6;
                        lam1=cand1(iii+2)*candstr1.dlam;
                        bet1=cand1(iii+3)*candstr1.dbet-90;
                        sd1_1=cand1(iii+4)*candstr1.dsd1;
                        lam2=cand2(jjj+2)*candstr2.dlam;
                        bet2=cand2(jjj+3)*candstr2.dbet-90;
                        sd1_2=cand2(jjj+4)*candstr2.dsd1;

                        if mod(lam1-lam2,360) < dil
                            if abs(bet1-bet2) < dib
                                if abs(sd1_1-sd1_2) < dis
                                    cr1=cand1(iii+5)*candstr1.dcr;
                                    mh1=cand1(iii+6)*candstr1.dmh;
                                    h1=cand1(iii+7)*candstr1.dh;
                                    cr2=cand2(jjj+5)*candstr2.dcr;
                                    mh2=cand1(jjj+6)*candstr2.dmh;
                                    h2=cand2(jjj+7)*candstr2.dh;
                                    ncoin=ncoin+1;%ncoin
                                    fprintf(fid,' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e   %f <-> %f   %f <-> %f   %e <-> %e \r\n',...
                                        ncoin,fr1(ii),fr2(jj),lam1,lam2,bet1,bet2,sd1_1,sd1_2,cr1,cr2,mh1,mh2,h1,h2);
                                    break
                                end
                            end
                        end
                        ic=0;
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
end

fprintf(fid,'\r\n   Coincidences between %d and %d candidates.',N1,N2);
fclose(fid);
disp(['stop coin at ' datestr(now)])