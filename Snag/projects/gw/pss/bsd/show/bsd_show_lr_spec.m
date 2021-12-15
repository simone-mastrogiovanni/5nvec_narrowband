function out=bsd_show_lr_spec(addr,tab)
% shows low res spectral characteristics of the bsds in a table 
%
%   addr   BSD address
%   tab    BSD table

% Snag Version 2.0 - August 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic

nfil=height(tab);
tabpar=check_bsd_table(tab);
n_t=tabpar.n_t;
n_f=tabpar.n_f;

for i = 1:nfil
    [bsd, name]=load_tab_bsd(addr,tab,i);
    cont=cont_gd(bsd);
    tfstr=cont.tfstr;
    dfr=tfstr.dfr;
    ssred=tfstr.subsp.ssred1;
    Nsstim=tfstr.subsp.Nsstim;
    DFR=dfr*ssred;
    len_ss=tfstr.subsp.len_ss;
    if i == 1
        dt=tfstr.dt;
        band=1/dt;
        NFRmax0=len_ss*n_f;
        rhdens=zeros(NFRmax0,n_t);
        whdens=rhdens;
        whdens_med=rhdens;
        whdens0=rhdens;
        meanw=rhdens;
        stdw=rhdens;
        non0w=rhdens;
        frs=zeros(NFRmax0,1);
        lfft=zeros(n_t,n_f);
        npeaks=lfft;
        mi_abs_lev=lfft;
        FRIN=cont.inifr;
        inibands=(0:n_f-1)*band+FRIN;
        initims=(1:n_t)*0;
        initims(1)=tfstr.t0;
        NFR=0;
        NFR1=0;
        old_kt=1;
        NFRmax=0;
    end
    
    NFR1=NFR1+len_ss;
    
    kt=tabpar.kt(i);
    kfr=tabpar.kfr(i);
    fprintf('file %s   kt %d/%d   kfr %d/%d \n',name,kt,n_t,kfr,n_f)
    lfft(kt,kfr)=tfstr.lfft;
    npeaks(kt,kfr)=sum(tfstr.pt.npeaks);
    mi_abs_lev(kt,kfr)=cont.mi_abs_lev;
    
    if kt > old_kt
        initims(kt)=tfstr.t0;
        NFR=0;
        NFR1=0;
        old_kt=kt;
    end
    
    NFRmax=max(NFRmax,NFR1);
    
    hdens1=y_gd2(tfstr.subsp.hdens);%fprintf('%d %d %d %d %d \n',size(hdens1),i1,kt,len_ss)
    wn1=tfstr.subsp.wn;
    whdens1=wn1.*hdens1;
    whdens0(NFR+1:NFR+len_ss,kt)=mean(whdens1);%figure,semilogy(mean(whdens1))
    rhdens(NFR+1:NFR+len_ss,kt)=mean(hdens1);
    frs(NFR+1:NFR+len_ss)=cont.inifr+DFR*(0:len_ss-1);
    for j = 1:len_ss
        ii=find(whdens1(:,j)>0);
        if ~isempty(ii)
            whdens(NFR+j,kt)=mean(whdens1(ii,j));
            whdens_med(NFR+j,kt)=median(whdens1(ii,j));
            meanw(NFR+j,kt)=mean(wn1(ii,j));
            stdw(NFR+j,kt)=std(wn1(ii,j));
            non0w(NFR+j,kt)=length(ii)/Nsstim;
        end
    end
%     hdens(i1:i1+len_ss-1,kt)=hdens1(kt,:);
    NFR=NFR+len_ss;
end

% size(whdens),size(whdens0),NFR
whdens=whdens(1:NFRmax,:);
whdens_med=whdens_med(1:NFRmax,:);
whdens0=whdens0(1:NFRmax,:);
rhdens=rhdens(1:NFRmax,:);
meanw=meanw(1:NFRmax,:);
stdw=stdw(1:NFRmax,:);
non0w=non0w(1:NFRmax);
frs=frs(1:NFRmax);

out.ant=cont.ant;
out.run=cont.run;
out.dt=dt;
out.inibands=inibands;
out.bandw=band;
out.lfft=lfft;
out.npeaks=npeaks;
out.mi_abs_lev=mi_abs_lev;
out.frs=frs;
out.whdens=whdens;
out.whdens_med=whdens_med;
out.whdens0=whdens0;
out.rhdens=rhdens;
out.meanw=meanw;
out.stdw=stdw;
out.non0w=non0w;

out.dur=toc