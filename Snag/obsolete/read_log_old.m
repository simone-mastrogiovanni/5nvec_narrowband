function out=read_log(par,file)
%READ_LOG  reads pss log files
%
%  par.ev     cell array of event types
%     .stat   cell array of stat types
%     .par    >1 parameters
%     .com    >1 comments
%     .err    >1 errors
%
%  out.ev     output data structures
%     .stat
%     .par
%     .com
%     .err

if ~exist('file','var')
    file=selfile(' ');
end

fid=fopen(file);

all=0;
ipar=0;
icom=0;
ierr=0;
nev=0;
nstat=0;

if ~exist('par','var')
    all=1;
    ipar=1;
    icom=1;
    ierr=1;
else
    if par.par > 0
        ipar=1;
    end
    if par.com > 0
        icom=1;
    end
    if par.err > 0
        ierr=1;
    end
    nev=length(par.ev);
    nstat=length(par.stat);
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
    if len < 1
        continue
    end
    if line(1) == '!'
        kcom=kcom+1;
        out.com{kcom}=line(2:len);
    end
    if len > 4
        if strcmp(line(1:3),'***')
            kerr=kerr+1;
            out.err{kerr}=line(5:len);
        end
    end
    if len > 11
        if strcmp(line(1:7),'started')
            kcom=kcom+1;
            out.com{kcom}=line(1:len);
        end
        if kcom == floor(kcom/1000)*1000 & kcom > 0
            disp(sprintf('   %d comments found',kcom));
        end
        if strcmp(line(1:4),'stop')
            kcom=kcom+1
            out.com{kcom}=line(1:len);
        end
        if strcmp(line(1:5),'(PAR)')
            kpar=kpar+1;
            out.par(kpar).name=line(7:9);
            out.par(kpar).val=sscanf(line(12:len),'%f');
        end
        if kpar == floor(kpar/1000)*1000 & kpar > 0
            disp(sprintf('   %d parameters found',kpar));
        end
    end
    if len > 4
        if strcmp(line(1:4),'--> ')
            kev=kev+1;
            out.ev(kev).type=line(5:7);
            out.ev(kev).pars=sscanf(line(10:len),'%f');
        end
        if kev == floor(kev/1000)*1000 & kev > 0
            disp(sprintf('   %d events found',kev));
        end
    end
    if len > 4
        if strcmp(line(1:3),'>>>')
            kstat=kstat+1;
            out.stat(kstat).type=line(4:6);
            out.stat(kstat).pars=sscanf(line(8:len),'%f');
        end
        if kstat == floor(kstat/1000)*1000 & kstat > 0
            disp(sprintf('   %d stats found',kstat));
        end
    end
end