function corr=test_correction(test,resfile)
%
%   test     as created by crea_test
%   resfile  results file in the form:
% Fisica Applicata - I prova di esonero 
% 
% # Scheda 1   Nome ACCA GIORGIO    
%           >1234567890   
% &  1 - 10 >AABD C VBB            
% & 11 - 20 >BAC DSCCB   
% & 21 - 30 >             
%           >1234567890   
% 
% # Scheda 2   Nome BERTI MATTEO    
%           >1234567890   
% &  1 - 10 >CDCBA           
% & 11 - 20 >             
% & 21 - 30 >   
%              ...

% Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

fid=fopen(resfile);

nquest=test.nquest;
Ans='ABCDEFGHIL';

nc=0;
iop=0;

while (feof(fid) ~= 1)
    str=fgetl(fid);
    if length(str) < 1
        str=' ';
    end
    str1=str(1);
    switch str1
        case '#'
            nc=nc+1;
            sk=str2num(str(10:12));
            corr(nc).sk=sk;
            corr(nc).name=str(19:length(str));
            iop=1;
            ires=0;
            for j = 1:nquest
                cc(j)=test.tests{sk}.test(j).yresp;
            end
            corr(nc).corres=cc; 
        case '&'
            if iop == 1
                ic(ires+1:ires+10)=char2int(str(12:21),nquest);
                if ires+10 >= nquest
                    ic=ic(1:nquest);
                    ii=find(ic == -32);
                    ic(ii)=0;
                    nnd=length(ii); 
                    ncorr=length(find(ic-cc == 0));
                    
                    corr(nc).punti=ncorr*test.ok+(nquest-nnd-ncorr)*test.nok;
                    corr(nc).voto=floor(corr(nc).punti);
                    if corr(nc).voto > 30
                        corr(nc).voto=30;
                    end
                    iop=0;
                    corr(nc).resps=ic;
                    corr(nc).ncorr=ncorr;
                    corr(nc).nondate=nnd;
                end
                ires=ires+10;
            end
    end
end

fclose(fid);

n=length(corr);
ii=0;

fid1=fopen('results.txt','w');
fprintf(fid1,'%s \n\n',test.header);
fprintf(fid1,'        Risultati \n\n');

for i = 1:n
    if corr(i).nondate == nquest
        continue
    end
    fprintf(fid1,'%d  %s  corrette %d  non date %d  punti %.2f  VOTO %d \n',...
        corr(i).sk,corr(i).name,corr(i).ncorr,corr(i).nondate,corr(i).punti,corr(i).voto);
end
        
fprintf(fid1,'\n\n        Non presenti \n\n');
for i = 1:n
    if corr(i).nondate == nquest
        fprintf(fid1,'%d  %s  \n',corr(i).sk,corr(i).name);
    end
end

fclose(fid1);




function ic=char2int(str,nquest)
% ic = -32  risposta non data

ic=double(str)-64;
