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

% save HSPOT

job_info.proc.G1_bsd_hspot.vers='170230';
job_info.proc.G1_bsd_hspot.tim=datestr(now);

switch typ
    case 2
        [peatot,spotstr,M,job_info,checkG]=bsd_hspot_ref(typ,candin,proc_info,job_info,peaks,patch);
    case 3
        [peatot,spotstr,job_info,checkG]=bsd_hspot_fu(typ,candin,proc_info,job_info,peaks,patch);
        M=1;
    case 4
        [peatot,spotstr,M,job_info,checkG]=bsd_hspot_dir(typ,candin,proc_info,job_info,peaks,patch);
end

kkkk=job_info.proc.G_bsd_hspot.kkkk;
DF=job_info.proc.G_bsd_hspot.DF;
nDF=job_info.proc.G_bsd_hspot.nDF;
dfr=job_info.proc.G_bsd_hspot.dfr;
dsd=job_info.proc.G_bsd_hspot.dsd;
nl=job_info.proc.G_bsd_hspot.nl;
nb=job_info.proc.G_bsd_hspot.nb;
refpat=job_info.proc.G_bsd_hspot.refpat;
nDF2=(nDF+1)/2;

kkkk,size(peatot)

[hfdf,~,checkE]=bsd_hough(typ,peatot,proc_info,job_info);

checkG.peatot=peatot;
y=y_gd2(hfdf);  
gfr=x_gd2(hfdf);
gsd=x2_gd2(hfdf);

%[im,ym,n1,n2]=bsd_find_peaks(y);
% [ii23,mm23,n123,n223,pks23,locsd23,locfr23]=bsd_find_peaks_1(y);

[ym,im,n1,n2,pks,locsd,locfr]=bsd_find_peaks(y);

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

err=cell(1,1);
i=1;

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

if M == 1
    skymax1=zeros(1,kkkk);
    skysd1=skymax1;
    skyfr1=skymax1;

    kk=0
    for j = 1:kkkk
        i1=(j-1)*nDF*2;
        [skymax1(j),kk]=max(ym2(i1+1:i1+nDF*2));
        skyfr1(j)=kk;
        kk=kk+i1;
        skysd1(j)=im(kk);
    end
    skymax1=reshape(skymax1,nb,nl);
    skyfr1=reshape(skyfr1,nb,nl);
    skysd1=reshape(skysd1,nb,nl);
    
    candout(1:9,1)=candin(1:9,1);
    
    dlam=spotstr.lam(2)-spotstr.lam(1);
    lam0=spotstr.lam0;
    bet0=spotstr.bet0;
    
    skymax=gd2(skymax1);
    skymax=edit_gd2(skymax,'ini2',spotstr.lam(1)-lam0,'dx2',dlam,'x',spotstr.bet-bet0);
    plot(skymax),title('max'),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on
    
    skyfr=gd2(skyfr1);
    skyfr=edit_gd2(skyfr,'ini2',spotstr.lam(1)-lam0,'dx2',dlam,'x',spotstr.bet-bet0);
    plot(skyfr),title('frequency correction'),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on
    
    skysd=gd2(skysd1);
    skysd=edit_gd2(skysd,'ini2',spotstr.lam(1)-lam0,'dx2',dlam,'x',spotstr.bet-bet0);
    plot(skysd),title('spin-down correction'),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on
        
    spotstr.skymax=skymax;
    spotstr.skyfr=skyfr;
    spotstr.skysd=skysd;
    
    skymax1=skymax1(:);
    [skyfr1,isfr]=sort(skyfr1(:));
    figure,plot(skyfr1,skymax1(isfr),'.'),grid on,title('frequency max'),xlabel('frequency')
    [skysd1,issd]=sort(skysd1(:));
    figure,plot(skysd1,skymax1(issd),'.'),grid on,title('spin-down max'),xlabel('spin-down')
end

bias0=job_info.proc.G_bsd_hspot.bias0;
% candout(10,i)=candin(1,i)+(mf-nDF2)*dfr; % ...+mf*dfr-checkG.bias
candout(10,i)=candin(1,i)+mf*dfr-bias0; % ...+mf*dfr-checkG.bias
candout(11,i)=refpat(1,msky);
candout(12,i)=refpat(2,msky);
candout(13,i)=candin(4,i)+(msd-ksd0)*dsd;
candout(14,i)=ymm(i);
candout(15,i)=ymm(i)*candin(6)/candin(5);

spotstr.hfdf=hfdf;
spotstr.candout=candout;
spotstr.masc=masc;
spotstr.skymax=skymax;
spotstr.skysd=skysd;

checkG.y=y;
checkG.DF=DF;
checkG.nDF=nDF;
% checkG.FenhSD=FenhSD;
% checkG.nFenhSD=nFenhSD;
checkG.ym=ym;
checkG.im=im;
checkG.ymm=ymm;
checkG.jmm=jmm;
checkG.err=err;

i1=1;
iii=0;

checkG.A=checkE.A;
checkG.checkE=checkE;


  
   
   
   
  