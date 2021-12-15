function out=print_test(test,filout)
%
%   test     as created by crea_test
%   filout   output file
%   names    (if present) file with list of names

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=[];
Ans='ABCDEFGHIL';

fid=fopen(filout,'w');
fid1=fopen('correction.txt','w');
fid2=fopen('feed-back.txt','w');

N=test.Ntest;
nquest=test.nquest;

fprintf(fid1,'%s \n\n',test.header);
fprintf(fid2,'%s \n\n',test.header);

for i = 1:N
    fprintf(fid,'%s \n\n',test.header);
    fprintf(fid,'Scheda %d \n',test.tests{i}.n);
    fprintf(fid1,'# Scheda %d   Nome %s    \n',test.tests{i}.n,test.tests{i}.name);
    fprintf(fid1,'          >1234567890   \n');
    fprintf(fid1,'&  1 - 10 >             \n');
    fprintf(fid1,'& 11 - 20 >             \n');
    fprintf(fid1,'& 21 - 30 >             \n');
    fprintf(fid1,'          >1234567890   \n\n');
    if isfield(test,'class')
        fprintf(fid,'Cognome e nome %s    \n',test.tests{i}.name);
        fprintf(fid,'Corso di laurea %s \n',test.class);
    else 
        fprintf(fid,'Cognome e nome %s    classe %s \n',test.tests{i}.name,test.tests{i}.class);
    end
    for j = 1:nquest
        fprintf(fid,'\nDomanda %d : %s \n',j,test.tests{i}.test(j).text);
        resp=test.tests{i}.test(j).resp;
        nresp=length(resp);
        for k = 1:nresp
            fprintf(fid,'  %s %s \n',Ans(k),resp{k});
        end
    end
    fprintf(fid,'\n\n');
end

for i = 1:test.nquestot
    fprintf(fid2,' %d %s \n',i,test.test_it(i).text);
    fprintf(fid2,'    %s \n\n',test.test_it(i).resp{test.test_it(i).yresp});
end

fclose(fid);
fclose(fid1);
fclose(fid2);