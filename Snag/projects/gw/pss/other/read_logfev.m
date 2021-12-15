function [t f d a cr out]=read_logfev(filout,filin)
%READ_LOG  reads pss log files
%
%  filout  if exist; 0 is equivalent to non-existence
%
%  out       output data structures
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
x=zeros(1,10000);
t=x;
f=t;
a=t;
cr=t;
d=t;

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
        if strcmp(line(5:7),'NEW')
            cel=multi_token(line);
            tt=eval(cel{4});
            continue
        end
        if strcmp(line(5:7),'EVF')
            kev=kev+1;
            if floor(kev/10000)*10000 == kev
                t=[t x];
                f=[f x];
                a=[a x];
                cr=[cr x];
                d=[d x];
                disp(kev)
            end
            cel=multi_token(line);
            t(kev)=tt;
            f(kev)=eval(cel{4});
            a(kev)=eval(cel{7})*1.e-20;
            d(kev)=eval(cel{5});
            cr(kev)=eval(cel{6});
        end
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

disp(sprintf('  %d  time event found',kev))

if fidout > 0
    fprintf(fidout,'   File  %s \n\n',filin);
    
    for i = 1:length(out.com)
        fprintf(fidout,'%s \n',out.com{i});
    end
    fprintf(fidout,' \n');
    for i = 1:length(out.par)
        fprintf(fidout,'         %-20s  %f \n',out.par(i).name,out.par(i).val);
    end
    fclose(fidout)
end

t=t(1:kev);
f=f(1:kev);
a=a(1:kev);
cr=cr(1:kev);
d=d(1:kev);
datestr(now)