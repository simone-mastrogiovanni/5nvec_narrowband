function [peatot,spotstr,job_info,checkG]=bsd_hspot_fu(typ,cand,proc_info,job_info,peaks,patch)
% refines the candidates or analyze a spot
%
%   [spotstr,job_info,checkG]=hfdf_spot(typ,candin,basic_info,job_info,peaks,patch)
%
%   typ         1-> 1 ??, 2 refinement (or multicell ??), 3 follow-up, 4 directed
%   cand        raw candidate (9,M)
%   proc_info   procedure info structure
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
% by S.D'Antonio, O.Piccinni, S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

save HSPOT
tic;
checkG=struct();

job_info.proc.G1_bsd_hspot.vers='170230';
job_info.proc.G1_bsd_hspot.tim=datestr(now);

dfr0=proc_info.hm.fr(2);
dsd0=proc_info.hm.sd(2);
dsd02=dsd0/2;

peaks_par=proc_info.peaks_par;
vdir=peaks_par.vdirect;
dvdir=peaks_par.dvdirect;checkG.peaks_par=peaks_par;
% peaks_par.Tvel_pt
pt=peaks_par.pt;
FenhSD=4*peaks_par.dfr;

Nt=length(pt.tpeaks); 
ntotpeaks=pt.ntotpeaks; 
index=pt.index; 
t=(peaks(1,:)-proc_info.epoch)*86400; 
pfr=peaks(2,:);   

amaxt=max(abs(t));
maxt=max(t);
mint=min(t);
checkG.ttt=[amaxt,mint,maxt];

meanpea=[];
peatot=[];

fftgain=proc_info.fu.fftgain;

dfr=proc_info.hm.fr(2)/(proc_info.hm.fr(3)*fftgain); 
dsd=dsd0/fftgain; 

fr0=cand(1);
ND0=2*ceil(1.06e-4*fr0/dfr0); % "full Doppler band"
ND=round(ND0*fftgain);
dsky=proc_info.fu.nsky*(patch(3)+patch(4)-patch(5))/2;
lam0=patch(1);
bet0=patch(2);
[smap,lam,bet]=pss_optmap_spot(ND,proc_info.fu.skyres,lam0,bet0,dsky);
refpat=smap(:,1:2)';

nl=length(lam);
nb=length(bet);

[Tug, kkp, kkv]=intersect(peaks(1,:),peaks_par.Tvel_pt);
nkk=length(kkp);
kkp(nkk+1)=length(peaks(1,:))+1;
dvdir1=dvdir(1,kkv);
dvdir2=dvdir(2,kkv); % only right time 
dvdir3=dvdir(3,kkv);
dvlam=zeros(length(lam),length(kkv));
dvbet=dvlam;
dvtot=dvlam;
for isa =1:nl
     dvlam(isa,:)=(lam(isa)-lam0).*dvdir1;
end
for isa =1:nb
    if (bet(isa)-bet0) > 0
        dvbet(isa,:)=(bet(isa)-bet0).*dvdir2;
    else
        dvbet(isa,:)=(bet(isa)-bet0).*dvdir3;
    end
end

jj=0;
for i = 1:nl
    for j = 1:nb
        jj=jj+1;
        dvtot(jj,:)=dvlam(i,:)+dvbet(j,:);
    end
end
kkkk=nl*nb;

maxadvlam=max(abs(dvlam(:)));maxadvlam
maxadvbet=max(abs(dvbet(:)));maxadvbet
maxadv=maxadvlam+maxadvbet;

frc=cand(1); % frc1=[frc1 frc];
sdc=cand(4);
asdc=abs(sdc);
dfpos=maxadv*frc;
frp1=-amaxt*(asdc+dsd02)-dfpos+frc;
frp4=amaxt*(asdc+dsd02)+dfpos+frc; frp{i}=[frp1 frp4];

DF=2*(dsd0*amaxt+FenhSD+dfpos);

nFenhSD=ceil(FenhSD/dfr);
nDF=round(DF/(2*dfr))*2+1;
nDF2=(nDF+1)/2;
DF=nDF*dfr;
bias0=DF*3/2;

skybias=(0:kkkk-1)*2*DF;
job_info.proc.G_bsd_hspot.DF=DF;
job_info.proc.G_bsd_hspot.nDF=nDF;
job_info.proc.G_bsd_hspot.dfr=dfr; % dfr followup
job_info.proc.G_bsd_hspot.dsd=dsd; % dsd followup
% job_info.proc.G_bsd_hspot.nsky=kkkk;
job_info.proc.G_bsd_hspot.kkkk=kkkk;
job_info.proc.G_bsd_hspot.nl=nl;
job_info.proc.G_bsd_hspot.nb=nb;
job_info.proc.G_bsd_hspot.nf=nDF*(kkkk*2+1);
job_info.proc.G_bsd_hspot.nsd=2*round(proc_info.fu.nsd*fftgain)+1;
job_info.proc.G_bsd_hspot.refpat=refpat;

ii=find((frp1<=pfr & frp4>=pfr));
pea=peaks(1:5,ii);
checkG.pea=pea;
npea=length(ii);
bias=-frc+bias0;
pea0=pea;
pea(2,:)=pea(2,:)-sdc*t(ii)-frc+bias0;%+bias(i);
pea1=pea;
meanpea=[meanpea mean(pea(2,:))]
% maxfp=max(pea(2,:)) 

[Tug1, kkp1,kkv1]=intersect(pea(1,:),peaks_par.Tvel_pt);
nkk1=length(kkp1);
kkp1(nkk1+1)=length(pea(1,:))+1;

dvdir1=dvdir(1,kkv1);
dvdir2=dvdir(2,kkv1); % only right time 
dvdir3=dvdir(3,kkv1);

dvlam=zeros(length(lam),length(kkv1));
dvbet=dvlam;
dvtot=dvlam;
for isa =1:nl
     dvlam(isa,:)=(lam(isa)-lam0).*dvdir1;
end
for isa =1:nb
    if (bet(isa)-bet0) > 0
        dvbet(isa,:)=(bet(isa)-bet0).*dvdir2;
    else
        dvbet(isa,:)=(bet(isa)-bet0).*dvdir3;
    end
end

jj=0;
for i = 1:nl
    for j = 1:nb
        jj=jj+1;
        dvtot(jj,:)=0*(dvlam(i,:)+dvbet(j,:));
    end
end
for j = 1:kkkk
    for ll=1:nkk1
%         pea1(2,kkp1(ll):kkp1(ll+1)-1)=pea(2,kkp1(ll):kkp1(ll+1)-1)-dvtot(j,ll)*frc+skybias(j);
        pea1(2,kkp1(ll):kkp1(ll+1)-1)=pea0(2,kkp1(ll):kkp1(ll+1)-1)*(1-dvtot(j,ll));%+skybias(j)-sdc*t(ii)-frc+bias0;
    end
    %%
pea1(2,:)=pea1(2,:)+skybias(j)-sdc*t(ii)-frc+bias0;
    %
    peatot=[peatot, pea1];
end

[tt,ii]=sort(peatot(1,:));
peatot=peatot(:,ii);

spotstr.skybias=skybias;
spotstr.lam=lam;
spotstr.bet=bet;
spotstr.smap=smap;
spotstr.FenhSD=FenhSD;
spotstr.DF=DF;
spotstr.dfr=dfr;
spotstr.dsd=dsd;
spotstr.dvtot=dvtot;

checkG.bias=bias;
checkG.peatot=peatot;    
checkG.npea=npea; 
checkG.frp=frp;
checkG.bias0=bias0;
checkG.skybias=skybias;
checkG.meanpea=meanpea;


% 
% return
% for ij = 1:lind
%     iii=iii+1;
%     iiii=indr(iii);  % i1,NDF
%     ym1=ym(i1:i1+NDF-1);
%     im1=im(i1:i1+NDF-1);
%     i1=i1+NDF;
%     [ma,ima]=max(ym1);
%     falsfr=gfr(ima);
%     jj=round(falsfr/DF);
%     if jj > kkkk
%         fprintf('ERROR %f  cand %d\n',falsfr/DF,iii)
%         jj=kkkk;
%     end
%     if jj < 1
%         fprintf('ERROR %f  cand %d\n',falsfr/DF,iii)
%         jj=1;
%     end
%     candout(10,iiii)=falsfr-jj*DF+cand(1,ij);
%     candout(11,iiii)=refpat(1,jj);
%     candout(12,iiii)=refpat(2,jj);
%     candout(13,iiii)=gsd(im1(ima));
%     candout(14,iiii)=ma;
%     candout(15,iiii)=ma*candout(6,iii)/candout(5,iii);
% end
% 
% candout(13,:)=correct_sampling(candout(13,:),0,dsd);
% 
% checkG.hm=hm;
% job_info.proc.G_bsd_hspot.duration=toc(ttoc);
