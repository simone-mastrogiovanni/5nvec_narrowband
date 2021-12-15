function out=hfdf_checkjob_0(folder)
% checks input files created by HFDF_PREPJOB

i64=64;
folder=uigetdir(folder);
cd(folder)

list1=dir('in_*');
N=length(list1);
ii=0;

for i = 1:N
    if length(list1(i).name) == 20
        ii=ii+1;
        list(ii)=list1(i);
    end
end

out.folder=folder;
out.list=list;

veto_lines=[];
veto_lines_amp=[];

nfil=length(list);
ncand=zeros(1,nfil);
npatches=ncand;
band=ncand;
tottim=ncand;
bandjobs=ncand;

for i = 1:nfil
    name=list(i).name;
    a=load(name);
    fiel=fieldnames(a);
    fiel=fiel{1};
    eval(['struc=a.' fiel ';']);
    
    job_0=struc.job_0;
    disp(job_0);
    vrun=job_0(1:4);
%     setpp=str2num(job_0(6:7));
    fr(i)=str2num(job_0(9:12));
    eval(['run=' vrun '(' job_0(6:7) ');']);
    peaks=struc.peaks;
    basic_info=struc.basic_info;
    wsp=basic_info.wsp;
    W1=y_gd(wsp);
    wini1=ini_gd(wsp);
    if i == 1
        lfft=run.fft.len;
        nfft=run.fft.n;
        ffttim=basic_info.tim;
        st=run.st;
        anaband=run.anaband;
        nband=anaband(2)+anaband(3)-anaband(1);
        peakt=zeros(nfft,nband);
        wdf=dx_gd(wsp);
        wini=anaband(1);
        wini=fr(1);
        wn=round(anaband(3)/wdf);
        dfr=wdf;
        xfr=anaband(1)+dfr/2:dfr:anaband(2)+anaband(3);
        nn=length(xfr);
        npeakstot=zeros(1,nn);
        npeakstot0=npeakstot;
        npeakseff=zeros(1,nn);
        npeakseff0=npeakseff;
        nwientot=zeros(1,nn);
        out.run=run;
        NW=round(nband/wdf);
        W=zeros(NW,1);
        nw0=0;
        if isfield(basic_info,'NPeak')
            vers=2;
        else
            vers=1;
        end
        j0=0;
    end
    nw1=round((fr(i)-wini1)/wdf);
    nw2=nw1+wn-1;
    W(nw0+1:nw0+wn)=W1(nw1:nw2);
    nw0=nw0+wn;
    peakt(:,i)=basic_info.npeak_fft;
    
    ii=find(peaks(2,:) >= basic_info.frin & peaks(2,:) < basic_info.frfi);
    peaks=peaks(:,ii);
    npeakstot0=hist(peaks(2,:),xfr);
    npeakstot=npeakstot+npeakstot0;
    ii=find(peaks(4,:) > 0);
    peaks=peaks(:,ii);
    npeakseff0=hist(peaks(2,:),xfr);
    npeakseff=npeakseff+npeakseff0;
    for j = 1:i64
        ii=find(peaks(2,:) >= basic_info.frin+(j-1)*dfr & peaks(2,:) < basic_info.frin+j*dfr);
        nwientot(j0+j)=sum(peaks(4,ii));
    end
    j0=j0+i64;
    mode=basic_info.mode;
    npeaks_ori(i)=basic_info.npeaks_ori;
    npeaks(i)=basic_info.npeaks;
    veto_lines=[veto_lines mode.veto_lines'];
    veto_lines_amp=[veto_lines_amp full(mode.veto_lines_amp)];
    if vers == 2
        NPeak(i,:)=basic_info.NPeak;
    end
    bandjobs(i)=struc.bandjobs;
    tim(i)=basic_info.proc.A_read_peakmap.duration+...
        basic_info.proc.B_crea_peak_table.duration+...
        basic_info.proc.C_clear_peak_table.duration;
    clear(name);
end

wsp=gd(W);
wsp=edit_gd(wsp,'ini',wini,'dx',wdf);

if vers == 2
    NPeaks=sum(NPeak);
    NPeaks0=round(lfft*nfft*st*(anaband(2)+anaband(3)-anaband(1))/13.245);
    out.NPeaks0=NPeaks0;
    fprintf(' %d total peaks in the peak map (expected %d)\n',NPeaks(1),NPeaks0);
    fprintf(' %d after t-f filter (%.3f)\n',NPeaks(2),NPeaks(2)/NPeaks(1));
    fprintf(' %d after persistence filter (%.3f)\n',NPeaks(3),NPeaks(3)/NPeaks(1));
    fprintf(' %d after robust filter (%.3f)\n',NPeaks(4),NPeaks(4)/NPeaks(1));
    fprintf(' %d after hw inj. filter (%.3f)\n',NPeaks(5),NPeaks(5)/NPeaks(1));
end
fprintf('\n  Total time %.2f s \n',sum(tim));

out.wsp=wsp;
out.veto_lines=veto_lines;
out.veto_lines_amp=veto_lines_amp;
out.canc_peaks=sum(veto_lines_amp);
out.fr=fr;
out.npeaks=npeaks;
out.npeaks_ori=npeaks_ori;
out.totnpeaks=sum(npeaks);
out.totnpeaks_ori=sum(npeaks_ori);
out.xfr=xfr;
out.npeakstot=npeakstot;
out.npeakseff=npeakseff;
out.nwientot=nwientot;
if vers == 2
    out.NPeak=NPeak;
end
out.bandjobs=bandjobs;
out.tim=tim;
peakt=gd2(peakt);
peakt=edit_gd2(peakt,'x',ffttim-floor(ffttim(1)),'ini2',anaband(1),'dx2',anaband(3));
out.peakt=peakt;

figure,plot(veto_lines,veto_lines_amp,'.'),grid on
title('Veto lines'),xlabel('frequency'),ylabel('amplitude')

if vers == 2
    figure,plot(fr,NPeak(:,1),'k.'),hold on,grid on,plot(fr,NPeak(:,2),'ro')
    plot(fr,NPeak(:,3),'g.'),plot(fr,NPeak(:,4),'.')
    title('Peaks number (total,after t-f,after persistence,after robust filter)'),xlabel('frequency')
else
    figure,plot(fr,npeaks_ori,'r.'),hold on,grid on,plot(fr,npeaks)
end

figure,plot(fr,tim),hold on,grid on,plot(fr,tim,'r.')
title('pre-job time'),xlabel('frequency'),ylabel('s')

figure,plot(xfr,npeakstot,'g.'),hold on,grid on,plot(xfr,npeakseff,'.')
plot(xfr,nwientot,'r.')
title('peaks (g-tot, b-eff, r-wien)'),xlabel('frequency')

figure,semilogy(sqrt(wsp)),hold on,semilogy(sqrt(wsp),'r.')
title('h density'),xlabel('Hz'),grid on

plot(peakt),title('Peaks per fft'),xlabel('Time (days)'),ylabel('band (Hz)')