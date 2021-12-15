function out=bsd_tfstr_db_all(list,filout)
% access bsd db for synthetic results on tfstr
%
%        out=bsd_tfstr_db(list,what,par)
%
%    list    file list with path
%    filout  file to save the structure

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();

if ~exist('par','var')
    par=struct();
end
if ~isfield(par,'tim')
    par.tim=[0 1.0e6];
end
if ~isfield(par,'fr')
    par.fr=[0 1.0e6];
end

fidlist=fopen(list,'r');
nfiles=0;
nofiles=0;

while (feof(fidlist) ~= 1)
    str=fgetl(fidlist);
    str1=str(1);
    if strcmp(str1,'*')
        nofiles=nofiles+1;
        fprintf('  %s  NOT CONSIDERED \n',str);
        continue
    else
        nfiles=nfiles+1;
        file{nfiles}=str;
        fprintf('  %s \n',str);
    end
end
nfiles,nofiles

% check 
kk=0;

for i = 1:nfiles
    [pathstr,name,ext]=fileparts(file{i});
    if i == 1
        name_piece=bsd_name_piece(name);
        bsd_date=name_piece.date;
        page=1;
        PAGE(page).bsd_date=bsd_date;
    end
    
    name_piece=bsd_name_piece(name);
    if ~strcmp(bsd_date,name_piece.date)
        bsd_date=name_piece.date;
        nbands=kk;
        PAGE(page).nbands=nbands;
        page=page+1;
        PAGE(page).bsd_date=bsd_date;
        kk=0;
    end
    
    kk=kk+1;
end
PAGE(page).nbands=kk;

for i = 1:page
    fprintf('page %d %s  %d bands \n',i,PAGE(i).bsd_date,PAGE(i).nbands);
end

for i = 2:page
    if PAGE(i).nbands ~= PAGE(i).nbands
        display(' *** ERROR !  not equal bands in the run pages')
    end
end

display(' ')
display('  Check !')
pause(5)

nbands=PAGE(1).nbands;
npages=page;

skyp=zeros(1,nbands);

kk=0;

for i = 1:nfiles
    [pathstr,name,ext]=fileparts(file{i});
    load(file{i});
    eval(['tfstr=tfstr_gd(' name ');'])
    name
    
    if i == 1
        eval(['dt=dx_gd(' name ');']);
        name_piece=bsd_name_piece(name);
        bsd_date=name_piece.date;
        page=1;out.peaktype=tfstr.peaktype;
        out.ant=tfstr.ant;
        t0=tfstr.t0;
        gdlen=tfstr.gdlen;
        out.t00=t0;
        out.inifr=zeros(1,nbands);
        out.lfft=zeros(1,nbands);
        out.dfr=zeros(1,nbands);
        out.DT=zeros(1,nbands);
        PAGE(1).hdens=cell(1,nbands);
        PAGE(1).wn=cell(1,nbands);
        PAGE(1).tfhist=cell(1,nbands);
        PAGE(1).htfhist=cell(1,nbands);
        PAGE(1).tfhist0=cell(1,nbands);
        PAGE(1).htfhist0=cell(1,nbands);
        totpeak=zeros(1,nbands);
    end
    
    name_piece=bsd_name_piece(name);
    if ~strcmp(bsd_date,name_piece.date)
        bsd_date=name_piece.date;
        
        pers=gd(pers);
        pers=edit_gd(pers,'x',xpers);
        
        pers0=gd(pers0);
        pers0=edit_gd(pers0,'x',xpers0);
        
        PAGE(page).t0=t0;
        PAGE(page).gdlen=gdlen;
        PAGE(page).totpeak=totpeak;
        PAGE(page).ptf=ptf;
        PAGE(page).pers=pers;
        PAGE(page).perscut=perscutfr;
        PAGE(page).pers0=pers0;

        page=page+1;
        kk=0;
        t0=tfstr.t0;
        gdlen=tfstr.gdlen;
        PAGE(page).hdens=cell(1,nbands);
        PAGE(page).wn=cell(1,nbands);
        PAGE(page).tfhist=cell(1,nbands);
        PAGE(page).htfhist=cell(1,nbands);
        totpeak=zeros(1,nbands);
    end
    
    if page == 1
        out.inifr(i)=tfstr.inifr;
        out.bandw=tfstr.bandw;
        out.lfft(i)=tfstr.lfft;
        out.dfr(i)=tfstr.dfr;
        out.DT(i)=tfstr.DT;
        skyp(i)=tfstr.bsd_par.sky.nskypoint;
    end
    
    kk=kk+1;
    
    if kk == 1
        eval(['n=n_gd(' name ');']);
        ndays=ceil(n*dt/86400);
        ptf=zeros(ndays,nbands);
        pers=[];
        xpers=[];
        pers0=[];
        xpers0=[];
        perscutfr=[];
    end
    
    totpeak(kk)=tfstr.pt.ntotpeaks;
    
    for j = 1:length(tfstr.pt.tpeaks)
        jj=floor(tfstr.pt.tpeaks(j)-t0)+1; % j,jj,kk
        ptf(jj,kk)=ptf(jj,kk)+tfstr.pt.npeaks(j);
    end
    
    pers1=tfstr.clean.persist;
    xpers1=(0:length(pers1)-1)*tfstr.dfr+tfstr.inifr;
    pers=[pers pers1];
    xpers=[xpers xpers1];
    
    pers10=tfstr.clean.persist0;
    xpers10=(0:length(pers10)-1)*tfstr.dfr+tfstr.inifr;
    pers0=[pers0 pers10];
    xpers0=[xpers0 xpers10];
    
    perscut1=tfstr.clean.perscutfr;
    perscutfr=[perscutfr perscut1];
    
    tf=gd2(tfstr.clean.tfhist');
    tf=edit_gd2(tf,'ini',tfstr.clean.DT/2,'dx',tfstr.clean.DT,'ini2',tfstr.inifr+tfstr.clean.DF/2,'dx2',tfstr.clean.DF);
    tfh=gd(tfstr.clean.htfhist);
    tfh=edit_gd(tfh,'x',tfstr.clean.xhtfhist);
    
    tf0=gd2(tfstr.clean.tfhist0');
    tf0=edit_gd2(tf0,'ini',tfstr.clean.DT/2,'dx',tfstr.clean.DT,'ini2',tfstr.inifr+tfstr.clean.DF/2,'dx2',tfstr.clean.DF);
    tfh0=gd(tfstr.clean.htfhist0);
    tfh0=edit_gd(tfh0,'x',tfstr.clean.xhtfhist0);
    
    hdens{page,kk}=tfstr.subsp.hdens;
    PAGE(page).hdens{1,kk}=tfstr.subsp.hdens;
    w=edit_gd2(tfstr.subsp.hdens,'y',tfstr.subsp.wn);
    wn{page,kk}=w;
    PAGE(page).wn{1,kk}=w;
    PAGE(page).tfhist{1,kk}=tf;
    PAGE(page).htfhist{1,kk}=tfh;   
    PAGE(page).tfhist0{1,kk}=tf0;
    PAGE(page).htfhist0{1,kk}=tfh0;
    
    eval(['clear ' name])
end

out.nskypoints=skyp;

pers=gd(pers);
pers=edit_gd(pers,'x',xpers);

pers0=gd(pers0);
pers0=edit_gd(pers0,'x',xpers0);

PAGE(page).t0=t0;
PAGE(page).gdlen=tfstr.gdlen;
PAGE(page).totpeak=totpeak;
PAGE(page).ptf=ptf;
PAGE(page).pers=pers;
PAGE(page).pers0=pers0;
PAGE(page).perscut=perscutfr; size(hdens)

out.PAGE=PAGE;

if exist('filout','var')
    filout1=filout
    eval([filout ' = out;'])
    save(filout1,filout1,'-v7.3')
end
