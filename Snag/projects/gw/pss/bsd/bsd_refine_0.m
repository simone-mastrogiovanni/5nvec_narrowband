function [candout,job_info,checkG]=bsd_refine(candin,proc_info,job_info,peaks,patch)
% refines the candidates
%
%   [candout,job_info,checkG]=hfdf_refine(candin,basic_info,job_info,peaks,patch)
%
%   candin      raw candidates (9,M)
%   proc_info   bprocedure info structure
%   job_info    job info structure
%   peaks       peaks corrected for the patch
%   patch       patch used to compute the candidates
%
%   candout     refined candidates (15,M)
%   job_info    job info structure
%   checkG      service structure for test and debug
%
%  candout rows:
%
%         1	frequency (raw)
%         2	lambda (raw)
%         3	beta (raw)
%         4	spin-down (raw)
%         5	amplitude (raw)
%         6	CR (raw)
%         7	dlam
%         8	dbet
%         9	type
%         10	frequency (ref)
%         11	lambda (ref)
%         12	beta (ref)
%         13	spin-down (ref)
%         14	amplitude (ref)
%         15	CR (ref)

% Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.Piccinni, S.DÁntonio, S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ttoc=tic;
checkG=struct();

job_info.proc.G_bsd_refine.vers='170230';
job_info.proc.G_bsd_refine.tim=datestr(now);

if isfield(proc_info,'ref')
    ref=proc_info.ref;
else
    ref.skylayers=2;
    ref.sd.enh=6;
    ref.sd.min=-6;
    ref.sd.max=6;
end

job_info.proc.G_bsd_refine.refpar=ref;

peaks_par=proc_info.peaks_par;
vdir=peaks_par.vdirect;
dvdir=peaks_par.dvdirect;
pt=peaks_par.pt;
FenhSD=4*peaks_par.dfr;

npea0=200000;
[dummy,M]=size(candin);
candout=zeros(15,M);
candout(1:9,:)=candin;
Nt=length(pt.tpeaks); 
ntotpeaks=pt.ntotpeaks; 
index=pt.index; 
% hm_job_ref.oper=job_info.hm_job.oper; %
t=(peaks(1,:)-proc_info.epoch)*86400; 
pfr=peaks(2,:);

% dsd0=basic_info.run.sd.dnat/basic_info.mode.hm_job.sdenh; %
dsd0=proc_info.hm.sd(2);
dsd=dsd0/ref.sd.enh; 
% sdmin=basic_info.run.sd.min+dsd*ref.sd.min; %
% nsd=-ref.sd.min+ref.sd.max+1; %
% hm_job_ref.sd=[sdmin dsd nsd]; %

% rawsd=basic_info.run.sd.min:dsd0:basic_info.run.sd.max*1.00001; %
% nrawsd=length(rawsd);
% refsd=sdmin:dsd:basic_info.run.sd.max+dsd*ref.sd.max; %
% nrefsd=length(refsd);
% amaxsd=max(abs(refsd));
amaxt=max(abs(t)); %
maxt=max(t);
mint=min(t);
checkG.ttt=[amaxt,mint,maxt];
dfr=proc_info.hm.fr(2)/proc_info.hm.fr(3); %

% DF=dsd0*amaxt*2+FenhSD;
DF=dsd0*amaxt+FenhSD;
nFenhSD=ceil(FenhSD/dfr);
nDF=round(DF/(2*dfr))*2+1;
nDF2=(nDF+1)/2;
DF=nDF*dfr;
job_info.proc.G_bsd_refine.DF=DF;
job_info.proc.G_bsd_refine.nDF=nDF;
job_info.proc.G_bsd_refine.nSD=ref.sd.max-ref.sd.min+1;
job_info.proc.G_bsd_refine.nFenhSD=nFenhSD;

kk=ref.skylayers; % number of layers
kkk=2*kk+1;
kkkk=kkk^2;
checkG.kkkk=kkkk;
NDF=(kkkk+1)*nDF;
dlam=(patch(3)/kkk)*(-kk:kk);
dbet1=(patch(4)-patch(2))/kkk;
dbet2=(patch(5)-patch(2))/kkk;
dbet=[dbet1*(kk:-1:1) 0 dbet2*(1:kk)];size(dlam),size(dvdir)
dvlam=dlam'*dvdir(1,:);
dvbet=[dbet1*(kk:-1:1)'*dvdir(2,:); zeros(1,Nt); dbet2*(1:kk)'*dvdir(3,:)];
maxadvlam=max(abs(dvlam(:)));maxadvlam
maxadvbet=max(abs(dvbet(:)));maxadvbet
maxadv=sqrt(maxadvlam^2+maxadvbet^2);
refpat=zeros(2,kkkk);
v1=zeros(kkkk,Nt);
dv=v1;

checkG.dvlam=dvlam;
checkG.dvbet=dvbet;

jj=0;
for i = -kk:kk
    i1=i+kk+1;
    for j = -kk:kk
        j1=j+kk+1;
        jj=jj+1;
        refpat(1,jj)=patch(1)+dlam(i1);
        refpat(2,jj)=patch(2)+dbet(j1);
        dvpat(jj)=dvlam(i1)+dvbet(j1);
    end
end

% out=dopp_corr_residual(direc,T,icplot,ant);

tindex=zeros(1,ntotpeaks);
for i = 1:Nt
    tindex(index(i):index(i+1)-1)=i;
end

fr=peaks(2,:);
dfr1=proc_info.hm.fr(2)*1.5;
dsd02=dsd0/2; %dsd02=dsd02*2;
peatot=[];
bias=zeros(1,M);
skybias=(0:kkkk-1)*2*DF;
bias0=DF*3/2;
frc1=[];
frp=cell(M,1);
meanpea=[];

for i = 1:M
    cand=candin(:,i);
    frc=cand(1); frc1=[frc1 frc];
    sdc=cand(4);
    asdc=abs(sdc);
    dfpos=maxadv*frc;
    frp1=-amaxt*(asdc+dsd02)-dfpos+frc;
    frp2=-amaxt*(asdc-dsd02)+dfpos+frc;
    frp3=amaxt*(asdc-dsd02)-dfpos+frc;
    frp4=amaxt*(asdc+dsd02)+dfpos+frc; frp{i}=[frp1 frp2 frp3 frp4];
    
    ii=find((frp1<=pfr & frp2>=pfr) | (frp3<=pfr & frp4>=pfr));
    pea=peaks(1:5,ii);
    npea(i)=length(ii);
%     bias(i)=-frc+DF*2*(kkkk*(i-1)+1);
    bias(i)=-frc+bias0+2*kkkk*(i-1)*DF;
    pea(2,:)=pea(2,:)-sdc*t(ii)+bias(i);
    meanpea=[meanpea mean(pea(2,:))];
    for j = 1:kkkk
        pea1=pea;
        pea1(2,:)=pea1(2,:)+dvpat(j)*frc+skybias(j); % ATTENZIONE forse *sdc*t(ii
        peatot=[peatot pea1];
    end
end
    
checkG.bias=bias;
checkG.peatot=peatot;    
checkG.npea=npea;  
checkG.frc1=frc1;
checkG.frp=frp;
checkG.bias0=bias0;
checkG.skybias=skybias;
checkG.meanpea=meanpea;

hfdf=bsd_hough(2,peatot,proc_info,job_info);
y=y_gd2(hfdf);  %y=randn(9074055,13);
gfr=x_gd2(hfdf);
gsd=x2_gd2(hfdf);
[ym,im]=max(y');
masc=ones(1,nDF*2*kkkk);
bb1=nDF+1;
bb2=2*nDF
for j = 1:kkkk
    masc(bb1:bb2)=0;
    bb1=bb1+2*nDF;
    bb2=bb2+2*nDF;
end

ymm=zeros(1,M);
jmm=ymm;
size(masc)
aa1=nDF+1;
aa2=(kkkk*2+1)*nDF;

err=cell(M,1);

for i = 1:M
    ym1=ym(aa1:aa2); 
    ym2=ym1.*masc;
    im1=im(aa1:aa2); 
    [ymm(i),jmm(i)]=max(ym2);
    aa1=aa1+2*kkkk*nDF;
    aa2=aa2+2*kkkk*nDF;
    msky=ceil(jmm(i)/(2*nDF));
    mf=jmm(i)-(msky-1)*2*nDF;
    msd=im1(jmm(i));
    err{i}=[msky,mf,msd];
end

checkG.y=y;
checkG.DF=DF;
checkG.nDF=nDF;
checkG.FenhSD=FenhSD;
checkG.nFenhSD=nFenhSD;
checkG.ym=ym;
checkG.im=im;
checkG.ymm=ymm;
checkG.jmm=jmm;
checkG.err=err;

i1=1;
iii=0;
checkG.hfdf=hfdf;



return
for ij = 1:lind
    iii=iii+1;
    iiii=indr(iii);  % i1,NDF
    ym1=ym(i1:i1+NDF-1);
    im1=im(i1:i1+NDF-1);
    i1=i1+NDF;
    [ma,ima]=max(ym1);
    falsfr=gfr(ima);
    jj=round(falsfr/DF);
    if jj > kkkk
        fprintf('ERROR %f  cand %d\n',falsfr/DF,iii)
        jj=kkkk;
    end
    if jj < 1
        fprintf('ERROR %f  cand %d\n',falsfr/DF,iii)
        jj=1;
    end
    candout(10,iiii)=falsfr-jj*DF+cand(1,ij);
    candout(11,iiii)=refpat(1,jj);
    candout(12,iiii)=refpat(2,jj);
    candout(13,iiii)=gsd(im1(ima));
    candout(14,iiii)=ma;
    candout(15,iiii)=ma*candout(6,iii)/candout(5,iii);
end

candout(13,:)=correct_sampling(candout(13,:),0,dsd);

checkG.hm=hm;
job_info.proc.G_hfdf_refine.duration=toc(ttoc);
