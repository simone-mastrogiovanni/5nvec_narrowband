function obsev=read_deca_resume(decadir,icshow)
% READ_DECA_RESUME  reads the deca_resumes
%
%   decadir   directory containing the decades
%   icshow    = 1 plot
%
%   obsev     observation periods (sev structure)

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(['directory ' decadir])
eval(['cd ' decadir])

appo=dir('deca*');
ndir=0;
for i = 1:length(appo)
    if appo(i).isdir
        ndir=ndir+1;
        dirs{ndir}=appo(i).name;
    end
end

nper=0;
t=zeros(1000,1);
dt=t;
nan=t;
n_nan=0;
for i = 1:ndir
    direc=dirs{i}
    eval(['cd ' direc])
    fileres=['resume_' direc '.txt'];
    fid=fopen(fileres);
    while 1
        tline=fgetl(fid);
        if ~ischar(tline)
            break
        end
        nn=findstr(tline,'start at');
        if ~isempty(nn)
            tim=sscanf(tline(nn+8:nn+21),'%f');
            n_nan=0;
        end
        nn=findstr(tline,'found');
        if ~isempty(nn) & nn < 30
            n_nan=sscanf(tline(nn+5:length(tline)),'%d');%,nn,disp('ciao'),tline(nn+5:length(tline))
        end
        nn=findstr(tline,'stop at');
        if ~isempty(nn)
            tim1=sscanf(tline(nn+7:nn+20),'%f');
            nper=nper+1;
            if floor(nper/nper)*1000+1 == 1001
                t(nper:nper+999)=0;
                dt(nper:nper+999)=0;
                nan(nper:nper+999)=0;
            end
            t(nper)=tim;
            dt(nper)=tim1-tim;
            nan(nper)=n_nan;
        end
    end
    eval(['cd ' decadir])
end

obsev.holes=zeros(nper-1,1);
for i = 1:nper-1
    obsev.holes(i)=t(i+1)-(t(i)+dt(i));
end

obsev.t=t(1:nper);
obsev.dt=dt(1:nper);
obsev.nan=nan(1:nper);
obsev.nper=nper;

if icshow > 0
    tin=obsev.t-floor(min(obsev.t));
    x=zeros(length(tin)*4,1);
    y=x;
    
    for i = 1:length(tin)
        i1=(i-1)*4;
        x(i1+1)=tin(i);
        x(i1+2)=tin(i);
        x(i1+3)=tin(i)+obsev.dt(i);
        x(i1+4)=tin(i)+obsev.dt(i);
        y(i1+1)=0;
        y(i1+2)=1;
        y(i1+3)=1;
        y(i1+4)=0;
    end
    
    figure,plot(x,y),grid on,ylim([0 2])
    title('Observation periods'),xlabel('days')
    
    [nh xh]=hist(obsev.dt,round(sqrt(nper)));
    xh=xh*24;
    ph=xh.*nh;
    ph=ph/sum(ph);
    figure,plot(xh,ph),grid on,hold on
    plot(xh,ph,'r.')
    title('fraction of data in a piece of a given length')
    xlabel('piece length (h)')
    ylabel('fraction')
    
    [nh1 xh1]=hist(obsev.holes,4*round(sqrt(nper)));size(obsev.holes),size(nh1),size(xh1)
    xh1=xh1*24*60;
    figure,plot(xh1,nh1),grid on,hold on
    plot(xh1,nh1,'r.')
    title('Histogram of hole length')
    xlabel('hole length (min)')
    
    t=obsev.t-floor(obsev.t(1));
    N=ceil(max(t));
    npiec=zeros(N,1);
    for i=1:N
        ii=find(t>i-1 & t<i);
        npiec(i)=length(ii);
    end
    figure,plot(npiec),hold on,plot(npiec,'r.'),grid on
    title('number of interruptions per day'),xlabel('day')
    
    on=zeros(N*1400,1);
    percon=zeros(N,1);
    for i = 1:length(tin)
        i1=round(tin(i)*1400+1);
        i2=round((tin(i)+obsev.dt(i))*1400);
        on(i1:i2)=1;
    end
    for i = 1:N
        percon(i)=sum(on((i-1)*1400+1:i*1400))/1400;
    end
    meanperc=mean(percon);
    figure,plot(percon),hold on,plot(percon,'r.'),grid on
    plot(ones(N,1)*meanperc,'g--')
    title('percentage of on time per day'),xlabel('day')
end
  
fclose('all')