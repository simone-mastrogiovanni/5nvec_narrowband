function check_transfer(filout,fil1,fil2)
% CHECK_TRANSFER  checks transferred files from dir lists

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('filout','var')
    filout='transfer_report.txt';
end

if ~exist('file1','var')
    file1=selfile('','Original dir file');
end

if ~exist('file2','var')
    file2=selfile('','Transferred dir file');
end

[files1,sizes1,dates1]=read_linuxdir(file1);
n1=length(sizes1);
[files2,sizes2,dates2]=read_linuxdir(file2);
n2=length(sizes2);

fid=fopen(filout,'w');
fprintf(fid,'          File transfer report \r\n');
fprintf(fid,'            %s \r\n\r\n',datestr(now));
fprintf(fid,'  %d in, %d out  \r\n\r\n',n1,n2);

n2a=1;
nx=0;
nerr=0;
nplus=0;
nless=0;
fil2=zeros(1,n2);

for i = 1:n1
    ic=0;
    for j = n2a:n2
        if strcmp(files1{i},files2{j})
            nx=nx+1;
            fil2(j)=fil2(j)+1;
            n2a=j+1;
            ic=1;
            if sizes1(i) ~= sizes2(j)
                fprintf(fid,'%s - %s original length %d, transferred %d \r\n',...
                    files1{i},dates1{i},sizes1(i),sizes2(j));
                nerr=nerr+1;
            end
            continue
        end
    end
    if ic == 0
        fprintf(fid,'%s - %s  not transferred \r\n',files1{i},dates1{i});
        nless=nless+1;
    end
end

for i = 1:n2
    if fil2(i) == 0
        fprintf(fid,'%s - %s not in original \r\n',files2{i},dates2{i});
        nplus=nplus+1;
    end
end

fprintf(fid,'\r\n  %d correctly transferred \r\n',n1-nless-nerr);
fprintf(fid,'  %d not transferred \r\n',nless);
fprintf(fid,'  %d wrong length \r\n',nerr);
fprintf(fid,'  %d alien files \r\n',nplus);

fclose(fid);