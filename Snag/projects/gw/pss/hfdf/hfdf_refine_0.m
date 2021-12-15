function [candout,job_info,checkG]=hfdf_refine_0(candin,basic_info,job_info,peaks,patch)
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

% Version 2.0 - November 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ttoc=tic;
checkG=struct();

job_info.proc.G_hfdf_refine.tim=datestr(now);

if isfield(basic_info.mode,'ref')
    ref=basic_info.mode.ref;
else
    ref.skylayers=2;
    ref.sd.enh=6;
    ref.sd.min=-10;
    ref.sd.max=10;
end

job_info.proc.G_hfdf_refine.refpar=ref;

[dummy,M]=size(candin);
hm=cell(M,1);
candout=zeros(15,M);
candout(1:9,:)=candin;
Nt=basic_info.ntim;
npeaks=basic_info.npeaks;
index=basic_info.index;
hm_job_ref.oper=basic_info.mode.hm_job.oper;

dsd0=basic_info.run.sd.dnat;
dsd=dsd0/ref.sd.enh;
sdmin=basic_info.run.sd.min+dsd*ref.sd.min;
nsd=-ref.sd.min+ref.sd.max+1;
hm_job_ref.sd=[sdmin dsd nsd];

vel=basic_info.velpos;
DF=basic_info.run.fr.dnat*12;
checkG.DF=DF;
checkG.nsd=nsd;
% sd=basic_info.run.sd;

v=vel(1:3,:);

kk=ref.skylayers; % number of layers
kkk=2*kk+1;
kkkk=kkk^2;
checkG.kkkk=kkkk;
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

    for j = 1:Nt
        v1(i,j)=dot(v(:,j),r);
    end
end

invindex=zeros(1,npeaks);
for i = 1:Nt
    dv(:,i)=v1(:,i)-v1((kkkk+1)/2,i);
    invindex(index(i):index(i+1)-1)=i;
end

fr=peaks(2,:);
dfr1=basic_info.run.fr.dnat*2;

for i = 1:M
    pea=[];
    hm_job_ref.sd(1)=candin(4,i)+dsd*ref.sd.min;
    ii=find(abs(fr-candin(1,i)) <= dfr1);
    pea0=peaks(:,ii);
    invind=invindex(ii); 
    
    lii=length(ii);
    
    for j = 1:kkkk
        DF1=j*DF;
        pea1=pea0;
        pea1(2,(1:lii))=pea0(2,(1:lii)).*(1-dv(j,invind))+DF1-candin(1,i);
        pea=[pea pea1];
    end
    
    tt=pea(1,:);
    [tt,it]=sort(tt);
    pea=pea(:,it);
    
    hfdf=hfdf_hough(pea,basic_info,job_info,hm_job_ref);
    y=y_gd2(hfdf);
    gfr=x_gd2(hfdf);
    gsd=x2_gd2(hfdf);
    [ym,im]=max(y,[],2); 
    [ma,ima]=max(ym);
    falsfr=gfr(ima);
    jj=round(falsfr/DF);
    if jj > kkkk
        jj=kkkk;
    end
    if jj < 1
        jj=1;
    end
    candout(10,i)=falsfr-jj*DF+candin(1,i);
    candout(11,i)=refpat(1,jj);
    candout(12,i)=refpat(2,jj);
    candout(13,i)=gsd(im(ima));
    candout(14,i)=ma;
    candout(15,i)=ma*candout(6,i)/candout(5,i);
%     hm{i}=hfdf;
end

checkG.hm=hm;
job_info.proc.G_hfdf_refine.duration=toc(ttoc);

