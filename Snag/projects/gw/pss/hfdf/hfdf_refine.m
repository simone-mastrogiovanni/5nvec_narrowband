function [candout,job_info,checkG]=hfdf_refine(candin,basic_info,job_info,peaks,patch)
% refines the candidates
%
%   [candout,job_info,checkG]=hfdf_refine(candin,basic_info,job_info,peaks,patch)
%
%   candin      raw candidates (9,M)
%   basic_info  basic info structure
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

% Version 2.0 - November 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ttoc=tic;
checkG=struct();

job_info.proc.G_hfdf_refine.vers='140630';
job_info.proc.G_hfdf_refine.tim=datestr(now);

if isfield(basic_info.mode,'ref')
    ref=basic_info.mode.ref;
else
    ref.skylayers=2;
    ref.sd.enh=6;
    ref.sd.min=-6;
    ref.sd.max=6;
end

job_info.proc.G_hfdf_refine.refpar=ref;

npea0=200000;
[dummy,M]=size(candin);
candout=zeros(15,M);
candout(1:9,:)=candin;
Nt=basic_info.ntim;
npeaks=basic_info.npeaks;
index=basic_info.index;
hm_job_ref.oper=job_info.hm_job.oper;
t=(peaks(1,:)-basic_info.run.epoch)*86400;

dsd0=basic_info.run.sd.dnat/basic_info.mode.hm_job.sdenh;
dsd=dsd0/ref.sd.enh;
sdmin=basic_info.run.sd.min+dsd*ref.sd.min;
nsd=-ref.sd.min+ref.sd.max+1;
hm_job_ref.sd=[sdmin dsd nsd];

rawsd=basic_info.run.sd.min:dsd0:basic_info.run.sd.max*1.00001;
nrawsd=length(rawsd);
refsd=sdmin:dsd:basic_info.run.sd.max+dsd*ref.sd.max;
nrefsd=length(refsd);
amaxsd=max(abs(refsd));
amaxt=max(abs(t));
dfr=basic_info.run.fr.dnat/basic_info.mode.hm_job.frenh;
FenhSD=2*amaxsd*amaxt;

hm=cell(nrawsd,1);
indrawsd=cell(nrawsd,1);

for i = 1:nrawsd
    ii=find(abs(rawsd(i)-candin(4,:))/dsd0 < 0.001);
    indrawsd{i}=ii;
end

vel=basic_info.velpos;
DF=basic_info.run.fr.dnat*16+FenhSD;
nDF=round(DF*basic_info.mode.hm_job.frenh/basic_info.run.fr.dnat); 
DF=nDF*basic_info.run.fr.dnat/basic_info.mode.hm_job.frenh;
checkG.DF=DF;
checkG.nsd=nsd;

v=vel(1:3,:);

kk=ref.skylayers; % number of layers
kkk=2*kk+1;
kkkk=kkk^2;
checkG.kkkk=kkkk;
NDF=(kkkk+1)*nDF;
dlam=(patch(3)/kkk)*(-kk:kk);
dbet1=(patch(4)-patch(2))/kkk;
dbet2=(patch(5)-patch(2))/kkk;
dbet=[dbet1*(kk:-1:1) 0 dbet2*(1:kk)];
refpat=zeros(2,kkkk);
v1=zeros(kkkk,Nt);
dv=v1;

jj=0;
for i = -kk:kk
    i1=i+kk+1;
    for j = -kk:kk
        j1=j+kk+1;
        jj=jj+1;
        refpat(1,jj)=patch(1)+dlam(i1);
        refpat(2,jj)=patch(2)+dbet(j1);
    end
end

for i = 1:kkkk
    [alpha,delta]=astro_coord('ecl','equ',refpat(1,i),refpat(2,i));
    r=astro2rect([alpha,delta],0);

%     for j = 1:Nt
%         v1(i,j)=dot(v(:,j),r);
%     end
    
    v1(i,:)=r*v; % DA BOLOGNA
end

tindex=zeros(1,npeaks);
for i = 1:Nt
    dv(:,i)=v1(:,i)-v1((kkkk+1)/2,i);
    tindex(index(i):index(i+1)-1)=i;
end

fr=peaks(2,:);
dfr1=basic_info.run.fr.dnat*1.5;

for i = 1:nrawsd
    lind=length(indrawsd{i});
    if lind <= 0
        continue
    end
%     hm_job_ref.mimaf0=[0 (kkkk+1)*DF*lind]; Commentato evita cadute su 90 gradi
    pea=zeros(5,npea0);
    npea=0;
    npea1=npea0;
    DF1=0;
    hm_job_ref.sd(1)=rawsd(i)+dsd*ref.sd.min;
    indr=indrawsd{i};
    cand=candin(:,indr);
    
    for ij = 1:lind
        ii=find(abs(fr-rawsd(i)*t-cand(1,ij)) <= dfr1);
        pea0=peaks(:,ii); 
        tind=tindex(ii); 

        lii=length(ii);

        for j = 1:kkkk
            DF1=DF1+DF;
            pea1=pea0;
            pea1(2,(1:lii))=pea0(2,(1:lii)).*(1-dv(j,tind))+DF1-cand(1,ij);
%             pea=[pea pea1];
            if npea+lii > npea1
                npea1=npea1+npea0+lii;
                pea(:,npea+1:npea1)=zeros(5,npea1-npea);
            end
            pea(:,npea+1:npea+lii)=pea1;
            npea=npea+lii;
        end
        DF1=DF1+DF;
    end
    
    pea=pea(:,1:npea);

    tt=pea(1,:);
    [tt it]=sort(tt);
    pea=pea(:,it);
    
    hfdf=hfdf_hough(pea,basic_info,job_info,hm_job_ref);
    y=y_gd2(hfdf);  % size(y),lind
    gfr=x_gd2(hfdf);
    gsd=x2_gd2(hfdf);
    [ym,im]=max(y');
    
    i1=1;
    iii=0;
    
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
%     hm{i}=hfdf;
end

candout(13,:)=correct_sampling(candout(13,:),0,dsd);

checkG.hm=hm;
job_info.proc.G_hfdf_refine.duration=toc(ttoc);
