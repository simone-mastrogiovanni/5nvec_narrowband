function [candout,job_info,checkG]=hfdf_refine_2016(candin,basic_info,job_info,peaks,patch)
%[candout,job_info,checkG]=hfdf_refine_2016_sabrina(candin,basic_info,job_info,peaks,patch)
% refines the candidates
%
%   [candout,job_info,checkG]=hfdf_refine(candin,basic_info,job_info,peaks,patch)
%
%   candin      raw candidates (9,M)
%   basic_info  basic info structure
%   job_info    job info structure
%   peaks       peaks corrected for the patch (correted by new hjdf_hough)
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
% by Sabrina D'Antonio & Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit? "Sapienza" - Rome

'REF'
I100=100;
I50=I100/2;%50;
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

[dummy,M]=size(candin);
candout=zeros(15,M);
candout(1:9,:)=candin;
Nt=basic_info.ntim;
npeaks=basic_info.npeaks;
index=basic_info.index;
hm_job_ref.oper=job_info.hm_job.oper;    % ?
t=(peaks(1,:)-basic_info.epoch)*86400;
dsd0=basic_info.run.sd.dnat/basic_info.mode.hm_job.sdenh;
dsd=dsd0/ref.sd.enh;
%sdmin=basic_info.run.sd.min+dsd*ref.sd.min; %% A che serve ?
nqsd=-ref.sd.min+ref.sd.max+1;

%rawsd=basic_info.run.sd.min:dsd0:(basic_info.run.sd.max+dsd0/100);    % ?
% nrefsd=length(refsd);
amaxsd=max(abs(ref.sd.min),abs(ref.sd.max))*dsd;
amaxt=max(abs(t));
dfr=basic_info.run.fr.dnat/basic_info.mode.hm_job.frenh;
deltaf2=round(basic_info.mode.hm_job.frenh/2+0.001); % semi-width of the strip (in ddf)
FenhSD=2*amaxsd*amaxt;

vel=basic_info.velpos;
checkG.nqsd=nqsd;

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
    v1(i,:)=r*v; % DA BOLOGNA
end

tindex=zeros(1,npeaks);
dvmax=0;
for i = 1:Nt
    dv(:,i)=v1(:,i)-v1((kkkk+1)/2,i);
    dvmax=max(dvmax,max(abs(dv(:,i))));
    tindex(index(i):index(i+1)-1)=i;
end

fr=peaks(2,:);
dfr1=basic_info.run.fr.dnat*1.5;
%  DF=basic_info.run.fr.dnat*16+FenhSD;
DF=FenhSD+2*dfr1;
nDF=round(DF/dfr);
nDF=ceil(nDF/2)*2+1;
% cenDF=ceil(nDF/2);
DF=nDF*dfr;
checkG.DF=DF;
hmax=zeros(3,kkkk);
nbinf=I50+nDF;
fbinf=nbinf*dfr;
ncent=ceil(nbinf/2);
fcent=(ncent-1)*dfr;

for i = 1:M
    cand=candin(:,i);
    frcand=cand(1);
    dvmaxf=dvmax*frcand/dfr; 
    frv=(fr-cand(4)*t);
    ii=find(abs(frv-frcand) <= dfr1);
%     inifr=min(peaks(2,ii))-DF/2-dfr/2;
%     finfr=max(peaks(2,ii))+DF/2+dfr/2;
%     nbin_f0=ceil((finfr-inifr)/dfr)+I100;
    tind=tindex(ii);
    tp0=t(ii);
    wp0=peaks(5,ii);
    wp0=0*wp0+1; %%!!! TOGLIERE
    [tt,ia]=unique(tp0);
    nTimeSteps=length(tt);
    ia(nTimeSteps+1)=length(tp0);
    L=length(ii);
    FF=zeros(L,kkkk);
    W=FF;
    for j = 1:kkkk
        FBIAS(j)=fcent+(j-1)*fbinf-frcand;
        frp0=peaks(2,ii).*(1-dv(j,tind));
        FF(:,j)=frp0+FBIAS(j);
        W(:,j)=wp0;
    end
    nbinf_tot=nbinf*kkkk;
    hmap=zeros(nqsd,nbinf_tot);
  
    for it = 1:nTimeSteps
        f0_a=FF(ia(it):ia(it+1)-1,:)/dfr-deltaf2;% (FF(ia(it):ia(it+1)-1),:)-inifr)/dfr;  % n
        w=W(ia(it):ia(it+1)-1,:);      
        th=tt(it);
        tddf=th/dfr;        
        id1=0;
        
        for id = ref.sd.min:ref.sd.max  % loop for the creation of half-differential map
            id1=id1+1;
%             td=(id*dsd+cand(4))*tddf; 
            td=id*dsd*tddf;   
            a=round(f0_a-td)+1;
            hmap(id1,a)=hmap(id1,a)+w(:)';%W; % left edge of the strips
        end
        
    end
    hmap(:,deltaf2*2+1:nbinf_tot)=...
        hmap(:,deltaf2*2+1:nbinf_tot)-hmap(:,1:nbinf_tot-deltaf2*2); % half to full diff. map - Carl Sabottke idea
    hmap=cumsum(hmap,2);   % creation of the Hough map
    [m,ir,ic]=maxmat(hmap);
    % da vedere
    isky=ceil(ic/nbinf);
    fri=(ic-1)*dfr;
%     if mod(ic,nbinf)>0
%         fri=mod(ic,nbinf)*dfr;
%     else
%         fri=nbin_f0*dfr+inifr-I50*dfr;
%     end
    candout(10,i)=fri-FBIAS(isky);
    candout(11:12,i)=refpat(1:2,isky);
    candout(13,i)=(ref.sd.min+ir)*dsd+cand(4);
    candout(14,i)=m;
    candout(15,i)=m*candout(6,i)/candout(5,i);
end

checkG.hmap=hmap;
job_info.proc.G_hfdf_refine.duration=toc(ttoc);