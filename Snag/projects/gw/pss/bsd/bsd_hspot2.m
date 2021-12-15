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

job_info.proc.G1_bsd_hspot.vers='170230';
job_info.proc.G1_bsd_hspot.tim=datestr(now);

switch typ
    case 2
        [spotstr,job_info,checkG]=bsd_hspot_ref(typ,candin,proc_info,job_info,peaks,patch);
    case 3
        [spotstr,job_info,checkG]=bsd_hspot_fu(typ,candin,proc_info,job_info,peaks,patch);
        M=1;
    case 4
        [spotstr,job_info,checkG]=bsd_hspot_dir(typ,candin,proc_info,job_info,peaks,patch);
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
        pea1(2,kkp1(ll):kkp1(ll+1)-1)=pea(2,kkp1(ll):kkp1(ll+1)-1)+dvtot(ll)+skybias(j)+maxfp*(j-1); % SABRINA per prova poi quello sotto ATTENZIONE forse *sdc*t(ii
        %pea1(2,:)=pea1(2,:)+dvtot(j)*frc+skybias(j); % ATTENZIONE forse *sdc*t(ii
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
spotstr.dvtot=dvtot;

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
