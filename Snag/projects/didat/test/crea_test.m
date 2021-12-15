function test=crea_test(N,nqmax,header,testfil,classname,cont)
% creates test
%
%    N          number of scrambled tests
%    nqmax      max number of questions
%    header     header
%    testfil    test file format:
%                 # nn # k correct response
%                 ? text
%                 ? ...
%                 ! resp1
%                 ! resp2
%                  ...
%               lines beginning with % are comments
%               other lines are not considered
%    classname  a string with classes (starting with "classes ")
%               or the name of a file with class, surname and name
%    cont       control (def cont.nresp=4, cont.resps='ABCD', cont.ok=2, cont.nok=-0.5)

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

seed=1023;
rng(seed);

if ~exist('classname','var')
    classname='.....................';
    icclass=0;
else
    ic8=min(8,length(classname));
    if classname(1:8) == 'classes '
        disp('Only classes')
        classname=classname(8:length(classname));
        icclass=1;
    else
        fid1=fopen(classname);
        icclass=2;
        cnam=cell(N,3);
        i=0;
        while (feof(fid1) ~= 1)
            str=fgetl(fid1);
            i=i+1;
            cnam(i,:)=strsplit(str,' ');
        end
        fclose(fid1);
    end
end

if ~exist('cont','var')
    cont.nresp=4;
    cont.resps='ABCD';
    cont.ok=2; 
    cont.nok=-0.5;
end

test.header=header;
if icclass < 2
    test.class=classname;
end

fidin=fopen(testfil,'r');
nn=0;
test_it=struct();

while (feof(fidin) ~= 1)
    str=fgetl(fidin);
    if length(str) < 1
        str=' ';
    end
    str1=str(1);
    switch str1
        case '#'
            nn=nn+1;
            ii=strfind(str,'#');
            test_it(nn).n=sscanf(str(ii(1)+1:ii(2)-1),'%d');
            test_it(nn).text=[];
            test_it(nn).resp=cell(1,cont.nresp);
            test_it(nn).yresp=sscanf(str(ii(2)+1:length(str)),'%d');
            if nn > 1
                if kk ~= cont.nresp
                    fprintf(' *** error on %d question: %d answers\n',nn,kk)
                end
            end
            kk=0;
        case '?'
            test_it(nn).text=[test_it(nn).text str(2:length(str))];
        case '!'
            kk=kk+1;
%             test_it(nn).resp{kk}=sscanf(str(2:length(str)),'%s');
            resp=str(2:length(str));
            test_it(nn).resp{kk}=resp;
        case '%'
            fprintf(' comment at nn = %d \n %s \n',nn,str(2:length(str)));
    end         
end

if kk ~= cont.nresp
    fprintf(' *** error on %d question: %d answers\n',nn,kk)
end
                
test.test_it=test_it;

fclose(fidin);

fprintf(' %d domande, ciascuna con %d risposte\n',nn,cont.nresp)

tests=cell(1,N);
nn1=min(nqmax,nn);
test.Ntest=N;
test.nquest=nn1;
test.nquestot=nn;
test.nresp=cont.nresp;
test.ok=cont.ok;
test.nok=cont.nok;

for i = 1:N
    p1 = randperm(nn);
    p2 = randperm(cont.nresp);
    ip2=inv_perm(p2);
    test1=test_it(p1);
    for j = 1:nn
        resp=test1(j).resp;
        for k = 1:cont.nresp
            test1(j).resp{k}=resp{p2(k)};
        end
        
        test1(j).yresp=ip2(test1(j).yresp);
    end
    
    test1=test1(1:nn1);
    
    test0.n=i;
    if icclass == 2
        test0.name=[cnam{i,2} ' ' cnam{i,3}];
        test0.class=cnam{i,1};
    else
        test0.name='..........................................';
    end
    test0.test=test1;
    tests{i}=test0;
end

test.tests=tests;



function ip=inv_perm(p)

[B,ip]=sort(p);