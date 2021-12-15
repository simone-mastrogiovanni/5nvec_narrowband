function [t a d cr ener band out]=read_logtbev(onlycent,filout,filin)
%READ_LOG  reads pss log files
%
%  onlycent   1 -> only the center part of the (interlaced) pieces
%  filout     if exist; 0 is equivalent to non-existence
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
x=zeros(1,1000);
t=x;
a=t;
d=t;
cr=t;
ener=t;
band=t;

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
            tinit=eval(cel{4});
            t1=tinit+(tfft/86400)/4;
            t2=tinit+3*(tfft/86400)/4;
        end
        if strcmp(line(5:7),'EVB')
            kev=kev+1;
            cel=multi_token(line);
            t(kev)=eval(cel{4});
            if onlycent == 1
                if t(kev) < t1 || t(kev) > t2
                    kev=kev-1;
                    continue
                end
            end
            d(kev)=eval(cel{5});
            a(kev)=eval(cel{6})*1.e-20;
            cr(kev)=eval(cel{7});
            ener(kev)=eval(cel{8});
            band(kev)=eval(cel{9});
            if floor(kev/1000)*1000 == kev
                t=[t x];
                a=[a x];
                d=[d x];
                cr=[cr x];
                ener=[ener x];
                band=[band x];
                disp(kev)
            end
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
            if strcmp(cel{2},'GEN_DELTANU')
                tfft=1/out.par(kpar).val;
            end
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

disp(sprintf('  %d  time band event found',kev))

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
a=a(1:kev);
d=d(1:kev);
cr=cr(1:kev);
ener=ener(1:kev);
band=band(1:kev);
datestr(now)