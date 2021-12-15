function [spotstr,job_info,checkG]=bsd_hspot(typ,candin,proc_info,job_info,peaks,patch)
% refines the candidates or analyze a spot
%
%   [spotstr,job_info,checkG]=hfdf_spot(typ,candin,basic_info,job_info,peaks,patch)
%
%   typ         1-> 1 ??, 2 refinement (or multicell ??), 3 follow-up, 4 directed
%   candin      raw candidates (9,M)
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

DF=2*(dsd0*amaxt+FenhSD);

meanpea=[];
peatot=[];

switch typ
    case 2
        if isfield(proc_info,'ref')
            ref=proc_info.ref;
        else
            ref.skylayers=2;
            ref.sd.enh=6;
            ref.sd.win=1;
        end

        ref.sd.min=-ref.sd.enh*ref.sd.win;
        ref.sd.max=ref.sd.enh*ref.sd.win;

        job_info.proc.G_bsd_hspot.refpar=ref;

        npea0=200000;
        [dummy,M]=size(candin);
        candout=zeros(15,M);
        candout(1:9,:)=candin;

        dsd=dsd0/ref.sd.enh; 

        dfr=dfr0/proc_info.hm.fr(3); 

        nFenhSD=ceil(FenhSD/dfr);
        nDF=round(DF/(2*dfr))*2+1;
        nDF2=(nDF+1)/2;
        DF=nDF*dfr;
        job_info.proc.G_bsd_hspot.DF=DF;
        job_info.proc.G_bsd_hspot.nDF=nDF;
        job_info.proc.G_bsd_hspot.nSD=ref.sd.max-ref.sd.min+1;
        job_info.proc.G_bsd_hspot.nFenhSD=nFenhSD;

        kk=ref.skylayers; % number of layers
        kkk=2*kk+1;
        kkkk=kkk^2;
        checkG.kkkk=kkkk;
%         NDF=(kkkk+1)*nDF;
        dlam=(patch(3)/kkk)*(-kk:kk);
        dbet1=(patch(4)-patch(2))/kkk;
        dbet2=(patch(5)-patch(2))/kkk;
        dbet=[dbet1*(kk:-1:1) 0 dbet2*(1:kk)];size(dlam),size(dvdir)
        dvlam=dlam'*dvdir(1,:);
        dvbet=[dbet1*(kk:-1:1)'*dvdir(2,:); zeros(1,Nt); dbet2*(1:kk)'*dvdir(3,:)];
        maxadvlam=max(abs(dvlam(:)));maxadvlam
        maxadvbet=max(abs(dvbet(:)));maxadvbet
        % maxadv=sqrt(maxadvlam^2+maxadvbet^2);
        maxadv=maxadvlam+maxadvbet;
        refpat=zeros(2,kkkk);
        skyp=refpat;
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
                skyp(1,jj)=i;
                skyp(2,jj)=j;
            end
        end

        checkG.skyp=skyp;
        checkG.refpat=refpat;
        checkG.dvpat=dvpat;
        % out=dopp_corr_residual(direc,T,icplot,ant);

        tindex=zeros(1,ntotpeaks);
        for i = 1:Nt
            tindex(index(i):index(i+1)-1)=i;
        end

        fr=peaks(2,:); 
        dfr1=proc_info.hm.fr(2)*1.5;
        bias=zeros(1,M);
        skybias=(0:kkkk-1)*2*DF;
        bias0=DF*3/2;
%         frc1=[];
        frp=cell(M,1);
    case 3
        M=1;
        fftgain=proc_info.fu.fftgain;

        dfr=proc_info.hm.fr(2)/(proc_info.hm.fr(3)*fftgain); 
        dsd=dsd0/fftgain; 

        nFenhSD=ceil(FenhSD/dfr);
        nDF=round(DF/(2*dfr))*2+1;
        nDF2=(nDF+1)/2;
        DF=nDF*dfr;
        bias0=DF*3/2;

        fr0=candin(1);
        ND0=2*ceil(1.06e-4*fr0/dfr0); % "full Doppler band"
        ND=round(ND0*fftgain);
        dsky=proc_info.fu.nsky*(patch(3)+patch(4)-patch(5))/2;
        lam0=patch(1);
        bet0=patch(2);
        [smap,lam,bet]=pss_optmap_spot(ND,proc_info.fu.skyres,lam0,bet0,dsky);
        refpat=smap(:,1:2)';
       
        nl=length(lam);
        nb=length(bet);
        
        [Tug kkp kkv]=intersect(peaks(1,:),peaks_par.Tvel_pt);
        nkk=length(kkp);
        kkp(nkk+1)=length(peaks(1,:));
        dvdir1=dvdir(1,kkv);
        dvdir2=dvdir(2,kkv); % only right time 
        dvlam=zeros(length(lam),length(kkv));
        dvbet=dvlam;
        dvpat=dvlam;
        for isa =1:length(lam)
             dvlam(isa,:)=(lam(isa)-lam0).*dvdir1;
        end
        for isa =1:length(bet)
             dvbet(isa,:)=(bet(isa)-bet0).*dvdir2;
        end
        
        jj=0;
        for i = 1:nl
            for j = 1:nb
                jj=jj+1;
                dvpat(jj,:)=dvlam(i,:)+dvbet(j,:);
            end
        end
        kkkk=nl*nb;
        skybias=(0:kkkk-1)*2*DF;
        job_info.proc.G_bsd_hspot.dfr_fu=dfr;
        job_info.proc.G_bsd_hspot.dsd_fu=dsd;
        job_info.proc.G_bsd_hspot.nsky=kkkk;
        job_info.proc.G_bsd_hspot.nf=nDF*(kkkk*2+1);
        job_info.proc.G_bsd_hspot.nsd=2*round(proc_info.fu.nsd*fftgain)+1;
        maxadvlam=max(abs(dvlam(:)));maxadvlam
        maxadvbet=max(abs(dvbet(:)));maxadvbet
        maxadv=maxadvlam+maxadvbet;
        
    case 4
end

for i = 1:M
    if M > 1
        cand=candin(:,i);
    else
        cand=candin;
    end
  
   
   
   
   %%%%%%%%%%%%%%%%%%
   
   
     %% SABRINA
    frc=cand(1); % frc1=[frc1 frc];
    sdc=cand(4);
    asdc=abs(sdc);
    dfpos=maxadv*frc;
    frp1=-amaxt*(asdc+dsd02)-dfpos+frc;
    frp4=amaxt*(asdc+dsd02)+dfpos+frc; frp{i}=[frp1 frp4];
    
    ii=find((frp1<=pfr & frp4>=pfr));
    pea=peaks(1:5,ii); 
    npea(i)=length(ii);
    bias(i)=-frc+bias0+2*kkkk*(i-1)*DF;
    pea(2,:)=pea(2,:)-sdc*t(ii)-frc+bias0+2*kkkk*(i-1)*DF;%+bias(i);
    meanpea=[meanpea mean(pea(2,:))]
    maxfp=max(pea(2,:)) 
    
    [Tug1 kkp1 kkv1]=intersect(pea(1,:),peaks_par.Tvel_pt);
    nkk1=length(kkp1);
    kkp1(nkk1+1)=length(pea(1,:));
   
    for j = 1:kkkk
        for ll=1:nkk1
        pea1(2,kkp1(ll):kkp1(ll+1)-1)=pea(2,kkp1(ll):kkp1(ll+1)-1)+dvpat(ll)+skybias(j)+maxfp*(j-1); % SABRINA per prova poi quello sotto ATTENZIONE forse *sdc*t(ii
        %pea1(2,:)=pea1(2,:)+dvpat(j)*frc+skybias(j); % ATTENZIONE forse *sdc*t(ii
        end
        peatot=[peatot pea1];
    end
end

peatot=sort(peatot,2);
    
kkkk,size(peatot)
checkG.bias=bias;
checkG.peatot=peatot;    
checkG.npea=npea;  
% checkG.frc1=frc1;
checkG.frp=frp;
checkG.bias0=bias0;
checkG.skybias=skybias;
checkG.meanpea=meanpea;

[hfdf,~,checkE]=bsd_hough(typ,peatot,proc_info,job_info);
checkG.peatot=peatot;
% return
y=y_gd2(hfdf);  
gfr=x_gd2(hfdf);
gsd=x2_gd2(hfdf);
% [ym,im]=max(y');
[im,ym,n1,n2]=bsd_find_peaks(y);
ksd0=(n2+1)/2;

masc=ones(1,nDF*(kkkk*2+1));
bb1=1;
bb2=nDF;
for j = 1:kkkk
    masc(bb1:bb2)=0;
    bb1=bb1+2*nDF;
    bb2=bb2+2*nDF;
end

ymm=zeros(1,M);
jmm=ymm;

aa1=1;
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
    
    candout(10,i)=candin(1,i)+(mf-nDF2)*dfr;
    candout(11,i)=refpat(1,msky);
    candout(12,i)=refpat(2,msky);
    candout(13,i)=candin(4,i)+(msd-ksd0)*dsd;
    candout(14,i)=ymm(i);
    candout(15,i)=ymm(i)*candin(6)/candin(5);
end

spotstr.hfdf=hfdf;
spotstr.candout=candout;
spotstr.skybias=skybias;
spotstr.lam=lam;
spotstr.bet=bet;
spotstr.smap=smap;
spotstr.FenhSD=FenhSD;
spotstr.DF=DF;
spotstr.dfr=dfr;
spotstr.dsd=dsd;
spotstr.masc=masc;
spotstr.dvpat=dvpat;

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

checkG.A=checkE.A;
checkG.checkE=checkE;


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
job_info.proc.G_bsd_hspot.duration=toc(ttoc);
