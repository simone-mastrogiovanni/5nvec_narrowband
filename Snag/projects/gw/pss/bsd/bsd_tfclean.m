function tfstr=bsd_tfclean(tfstr,anabasic)
% time-frequency cleaning
%
%   tfstr=bsd_tfclean(tfstr,anabasic)
%
%  - tf filter
%  - persistence
%  - noise adaptive filter
%
%    tfstr         tf structure as created by bsd_peakmap
%    anabasic      procedure control structure
%       .pers_thr  persistence threshold (0 -> no threshold; typical 0.3)
%       .tfh_df    time-frequency histogram df
%       .tfh_dt    time-frequency histogram dt (days) def 0.5
%       .tfh_pht   time-frequency histogram time phase (hours) def 8 local time
%       .tfh_thr   time_frequency threshold (0 -> no threshold)
%       .noplot    = 0  plot (default)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('anabasic','var')
    anabasic=struct();
end

if ~isfield(anabasic,'pers')
    anabasic.pers_thr=0.25;
end

if ~isfield(anabasic,'tfh_df')
    anabasic.tfh_df=0.01;
end

if ~isfield(anabasic,'tfh_dt')
    anabasic.tfh_dt=0.5;
end

if ~isfield(anabasic,'tfh_thr')
    anabasic.tfh_thr=0;
end

if ~isfield(anabasic,'tfh_pht')
    if strcmp(tfstr.ant,'virgo')
        anabasic.tfh_pht=(8-2)/24;
    end
    if strcmp(tfstr.ant,'ligol')
        anabasic.tfh_pht=(8+5)/24;
    end
    if strcmp(tfstr.ant,'ligoh')
        anabasic.tfh_pht=(8+7)/24;
    end
end

if ~isfield(anabasic,'noplot')
    anabasic.noplot=0;
end

npeaks=tfstr.pt.ntotpeaks;
nt=length(tfstr.pt.tpeaks);
% peaks=zeros(4,tfstr.ntotpeaks);
nfr=tfstr.bandw/tfstr.dfr;
nfr=round(nfr);
persist=zeros(1,nfr);
DF=anabasic.tfh_df;
NF=ceil(tfstr.bandw/DF)+1;
DT=anabasic.tfh_dt;
PHT=anabasic.tfh_pht;
NT=ceil((max(ceil(tfstr.pt.tpeaks))-min(floor(tfstr.pt.tpeaks)))/DT)+1;
tfstr.clean.nt=nt;
tfstr.clean.nfr=nfr;

tfhist=zeros(NF,NT); NF,NT
ii=0;
timp=tfstr.pt.peaks(1,:)-floor(tfstr.pt.peaks(1,1)); 

for i = 1:npeaks
    if tfstr.pt.peaks(2,i) > 0
        iifr=round((tfstr.pt.peaks(2,i)-tfstr.inifr)/tfstr.dfr)+1;
        ifr=round((tfstr.pt.peaks(2,i)-tfstr.inifr)/DF)+1;
        it=round((timp(i)-PHT)/DT)+2;
        tfhist(ifr,it)=tfhist(ifr,it)+1;
        persist(iifr)=persist(iifr)+1;
    end
end
persist=persist/nt;

tfstr.clean.NF=NF;
tfstr.clean.NT=NT;
tfstr.clean.DF=DF;
tfstr.clean.DT=DT;
tfstr.clean.PHT=PHT;
tfstr.clean.mpers=tfstr.pt.ntotpeaks/(nfr*nt);
tfstr.clean.persist=persist;
tfstr.clean.tfhist=tfhist;

aa=max(tfhist(:));
[h,x]=hist(tfhist(:),aa+1);

tfstr.clean.htfhist=h;
tfstr.clean.xhtfhist=x;

if anabasic.pers_thr > 0
    ii=find(persist >= anabasic.pers_thr);
    fr0=(ii-1)*tfstr.dfr+tfstr.inifr;
    
    for i = 1:length(ii)
        iii=find(abs(tfstr.pt.peaks(2,:)-fr0(i)) <= 1.e-6);
        
        for j = 1:length(iii)
            tfstr.pt.peaks(2,iii(j))=-abs(tfstr.pt.peaks(2,iii(j)));
        end
    end
    tfstr.clean.perscutfr=fr0;
end

if anabasic.tfh_thr > 0
    [ii,jj]=find(tfhist >= anabasic.tfh_thr);
    tfstr.clean.tfcut=tfhist*0;
    for i = 1:length(ii)
        ii1=find(tfstr.pt.peaks(2,:)-tfstr.inifr >= (ii(i)-2)*tfstr.clean.DF & tfstr.pt.peaks(2,:)-tfstr.inifr <= (ii(i)-1)*tfstr.clean.DF);
        jj1=find(timp >= (jj(i)-3)*tfstr.clean.DT+PHT & timp <= (jj(i)-2)*tfstr.clean.DT+PHT);
        kk1=intersect(ii1,jj1);
        tfstr.pt.peaks(2,kk1)=-abs(tfstr.pt.peaks(2,kk1));
        tfstr.clean.tfcut(ii(i),jj(i))=tfstr.clean.tfhist(ii(i),jj(i));
    end
    tfstr.clean.tfhist0=tfstr.clean.tfhist;
    tfstr.clean.htfhist0=tfstr.clean.htfhist;
    tfstr.clean.xhtfhist0=tfstr.clean.xhtfhist;
    tfstr.clean.persist0=tfstr.clean.persist;
    
    tfhist=zeros(NF,NT);
       
    for i = 1:npeaks
        if tfstr.pt.peaks(2,i) > 0
            iifr=round((tfstr.pt.peaks(2,i)-tfstr.inifr)/tfstr.dfr)+1;
            ifr=round((tfstr.pt.peaks(2,i)-tfstr.inifr)/DF)+1;
            it=round((timp(i)-PHT)/DT)+2;
            tfhist(ifr,it)=tfhist(ifr,it)+1;
            persist(iifr)=persist(iifr)+1;
        end
    end
    persist=persist/nt;

    tfstr.clean.persist=persist;
    tfstr.clean.tfhist=tfhist;

    aa=max(tfhist(:));
    [h,x]=hist(tfhist(:),aa+1);

    tfstr.clean.htfhist=h;
    tfstr.clean.xhtfhist=x;
    
    if anabasic.noplot == 0

    end
end

if anabasic.noplot == 0
    if anabasic.tfh_thr > 0
        figure,plot((0:nfr-1)*tfstr.dfr+tfstr.inifr,tfstr.clean.persist0,'r.-'),grid on
        hold on,plot((0:nfr-1)*tfstr.dfr+tfstr.inifr,tfstr.clean.persist,'.-'),grid on
        title('persistence (red before cut)'),xlabel('Hz'),ylabel('normalized persistence')
    
        figure,semilogy(tfstr.clean.xhtfhist0,tfstr.clean.htfhist0,'r'),grid on
        hold on,semilogy(tfstr.clean.xhtfhist,tfstr.clean.htfhist),grid on
        title(sprintf('band %d - %d Hz  (red before cut)',tfstr.inifr,tfstr.inifr+tfstr.bandw))
    else
        figure,plot((0:nfr-1)*tfstr.dfr+tfstr.inifr,tfstr.clean.persist,'.-'),grid on
        title('persistence'),xlabel('Hz'),ylabel('normalized persistence')
        figure,semilogy(tfstr.clean.xhtfhist,tfstr.clean.htfhist),grid on
        title(sprintf('band %d - %d Hz',tfstr.inifr,tfstr.inifr+tfstr.bandw))
    end
end