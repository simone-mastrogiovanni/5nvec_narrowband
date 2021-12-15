function out=read_log(filout,filin)
%READ_LOG  reads pss log files
%
%  filout  if exist; 0 is equivalent to non-existence
%
%  out.ev     output data structures
%     .stat
%     .par
%     .com
%     .err

datestr(now)
if ~exist('filin','var')
    filin=selfile(' ');
end

fid=fopen(filin);

fidout=0;
if exist('filout')
    if filout ~= 0
        fidout=fopen(filout,'w');
    end
end   

kpar=0;
kcom=0;
kerr=0;
kev=0;
kstat=0;

while 1
    line=fgetl(fid); % disp(line)
    if feof(fid)
        break
    end
    len=length(line);
    if len < 3
        continue
    end
    if strcmp(line(1:3),'-->')
        kev=kev+1;
        out.ev(kev).type=line(5:7);
        out.ev(kev).pars=sscanf(line(10:len),'%f');
        continue
    end
    
    if line(1) == '!'
        kcom=kcom+1;
        out.com{kcom}=line(2:len);
        continue
    end
    
    cel=multi_token(line);
    
    switch cel{1}
        case '>>>'
            kstat=kstat+1;
            out.stat(kstat).type=cel{2};
            out.stat(kstat).pars=eval(cel{4:length(cel)});
        case '(PAR)'
            kpar=kpar+1;
            out.par(kpar).name=cel{2};
            out.par(kpar).val=eval(cel{4});
        case 'started'
            kcom=kcom+1;
            out.com{kcom}=line;
        case 'stop'
            kcom=kcom+1;
            out.com{kcom}=line;
        case '***'
            kerr=kerr+1;
            out.err(kerr)=line;
    end
end

for i = 1:length(out.com)
    disp(sprintf('%s',out.com{i}))
end

disp(' ')
disp('            Parameters')
disp(' ')

for i = 1:length(out.par)
    str=sprintf('         %-20s  %f ',out.par(i).name,out.par(i).val);
    disp(str);
end

if fidout > 0
    fprintf(fidout,'   File  %s \n\n',filin);
    
    for i = 1:length(out.com)
        fprintf(fidout,'%s \n',out.com{i});
    end
    fprintf(fidout,' \n                   Parameters \n\n');
    for i = 1:length(out.par)
        fprintf(fidout,'         %-20s  %f \n',out.par(i).name,out.par(i).val);
    end
    fclose(fidout)
end
datestr(now)