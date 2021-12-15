function [ptout,ptout0,out]=veri_inv_hough(job_pack_0,sour,calib,lab,level,win)
% verification of the peaks from a source
%
%    job_pack_0   
%    sour         source (source structure or array[fr lam bet sd epoch])
%    calib        calibration structure or 0
%    lab          label
%    level        level (0 1 2 3) lower less
%    win          [max half-window step] in dfr units (def [10 0.25])
%
%    ptout        signal peakmap
%    ptout0       noise peakmap
%    out          output information structure

% Version 2.0 - March 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

if ~exist('lab','var')
    lab=' ';
end

if ~exist('level','var')
    level=3;
end

if ~exist('win','var')
    win=[10,0.25];
end

ptin=job_pack_0.peaks;
basic_info=job_pack_0.basic_info;
ant=basic_info.run.ant;
[a1,a2]=size(ptin);
ptout=zeros(a1+1,a2);

ptout(1:5,:)=ptin;
epoch=basic_info.epoch;
tim=(basic_info.tim-epoch)*86400;
vel=basic_info.velpos(1:3,:);
velpos=basic_info.velpos;
index=basic_info.index;
Nt=basic_info.ntim;
dfr=basic_info.dfr;
v1=zeros(1,Nt);

if ~isstruct(sour)
    sour1=sour;
    clear sour
    sour.f0=sour1(1);
    sour.df0=sour1(4);
    sour.ddf0=0;
    sour.fepoch=sour1(5);
    sour.pepoch=sour1(5);
    [ao,do]=astro_coord('ecl','equ',sour1(2),sour1(3));
    sour.a=ao;
    sour.d=do;
    sour.v_a=0;
    sour.v_d=0;
    sour.eta=1;
    sour.psi=0;
end
out.sour=sour;
out.sour_epoch=sour.fepoch;
out.local_epoch=epoch;
sour=new_posfr(sour,epoch);
fr0=sour.f0;
sd=sour.df0;
fr1=fr0+tim*sd;
alpha=sour.a;
delta=sour.d;
r=astro2rect([alpha,delta],0);

sidh=gmst(ptin(1,:));
sidpat=pss_sidpat_psi(sour,ant,120,0); %figure,plot(sidpat),title('sidpat')
radpat=gd_interp(sidpat,sidh);
radpat=radpat.*ptin(4,:);
radpat=radpat/mean(radpat);%figure,plot(radpat,'.'),title('radpat')

ptin(5,:)=radpat;

for i = 1:Nt
    v1(i)=dot(vel(:,i),r);
end

fr1=fr1.*(1+v1);
ips=0;
indout=index*0;
indout(1)=1;

for i = 1:Nt
    fr=ptin(2,index(i):index(i+1)-1);
    dist=(fr-fr1(i))/dfr;
    ii=find(abs(dist) <= win(1));
    nii=length(ii);
    if nii > 0
        i1=ips+1;
        ips=ips+nii;%sprintf('%d %d \n',i,nii)
        i2=ips;
        ptout(1:5,i1:i2)=ptin(:,index(i)-1+ii);
        ptout(6,i1:i2)=dist(ii);
    end
    indout(i+1)=ips+1;
end

ptout=ptout(:,1:ips);
out.tim=basic_info.tim;
out.velpos=velpos;
out.index=indout;

ii=find(ptout(4,:));
ptout=ptout(:,ii);  % Only non cancelled data
ips=length(ii);

% central data selection

nb=2;     % noise band limit
wnb=win(1)-nb;
sb=0.8;   % hough signal frequency half wide band
sb0=0.5;  % hough signal frequency half band
sb1=0.125; % hough signal frequency half narrowband

iis=find(abs(ptout(6,:)) < sb);
iis0=find(abs(ptout(6,:)) <= sb0);
iis1=find(abs(ptout(6,:)) <= sb1);
iin=find(abs(ptout(6,:)) > nb);

% Frequency distance distribution

xh=-win(1)+win(2)/2:win(2):win(1);
h=hist(ptout(6,:),xh);
wh1=whist(ptout(6,:),ptout(4,:),xh);
wh=whist(ptout(6,:),ptout(5,:),xh);
figure,stairs(xh,h),grid on,xlabel('normalized distance'),title(['Frequency distance (b norm, g nois wien, r wien' lab])
hold on,stairs(xh,wh1,'g'),stairs(xh,wh,'r')
normdisth=gd(h);
normdisth=edit_gd(normdisth,'ini',xh(1),'dx',win(2));
out.normdisth=normdisth;

if level > 0
    % Frequency distance distribution for amplitudes

    [wha,ov,un,wha1,W]=whist(ptout(6,:),ptout(3,:),xh);
    figure,stairs(xh,wha1),grid on,xlabel('normalized distance'),title(['Frequency distance for amplitude (b without weight ' lab])
    hold on,stairs(xh,wha,'r'),grid on,xlabel('normalized distance')
    figure,stairs(xh,wha./wha1),grid on,xlabel('normalized distance'),title(['Frequency distance only for amplitude' lab])
    figure,plot(W);title('Amplitude histograms')

    % Frequency distance distribution for wienered amplitudes

    [whaw,ov,un,wha1w,W]=whist(ptout(6,:),ptout(3,:).*ptout(5,:),xh);
    figure,stairs(xh,wha1w),grid on,xlabel('normalized distance'),title(['Frequency distance for wien amplitude (b without weight) ' lab])
    hold on,stairs(xh,whaw,'r'),grid on,xlabel('normalized distance')
    figure,stairs(xh,whaw./wha1w),grid on,xlabel('normalized distance'),title(['Frequency distance only for wien amplitude ' lab])
    figure,plot(W);title('Wienered Amplitude histograms')

    % Time distribution

    [whtad,ov,un,wht,W,xt]=whist(ptout(1,:),ptout(4,:),20);
    [whtad1,ov,un,wht1,W,xt1]=whist(ptout(1,iis0),ptout(4,iis0),20);
    [whtad1n,ov,un,wht1n,W,xt1]=whist(ptout(1,iin),ptout(4,iin),xt1);

    figure,stairs(xt-floor(xt(1)),wht,':'), hold on,stairs(xt-floor(xt(1)),whtad,'r'),grid on
    title(['Time distribution (b normal, r wien)' lab]),xlabel('days')

    figure,stairs(xt1-floor(xt1(1)),wht1,':'), hold on,stairs(xt1-floor(xt1(1)),whtad1,'r'),grid on
    title(['Central data time distribution (b normal, r wien)' lab]),xlabel('days')

    kb=wnb/sb0
    figure,stairs(xt1-floor(xt1(1)),kb*wht1./wht1n,':'), hold on,stairs(xt1-floor(xt1(1)),kb*whtad1./whtad1n,'r'),grid on
    title(['Central data time normalized distribution (b normal, r wien)' lab]),xlabel('days')
end

ntot=ips;
ns=length(iis);
ns0=length(iis0);
nn=length(iin);
noiseband=(win(1)-2)*2;
meannoise=nn/noiseband;
sig=ns-sb*2*meannoise;
meannoiseamp=mean(ptout(3,iin));
meansigamp=mean(ptout(3,iis));
hou=ns0;

fprintf('mean noise peaks %f   signal peaks %f  signal hough peak %f\n',meannoise,sig,hou)
fprintf('mean noise peaks amp %f   mean signal amplitude %f \n',meannoiseamp,meansigamp)

wmeannoise=sum(ptout(4,iin))/noiseband;
wsig=sum(ptout(4,iis))-sb*2*meannoise;
wmeannoiseamp=mean(ptout(3,iin).*ptout(4,iin));
wmeansigamp=mean(ptout(3,iis).*ptout(4,iis));
whou=sum(ptout(4,iis0));

fprintf('wiener mean noise peaks %f   signal peaks %f  signal hough peak %f\n',wmeannoise,wsig,whou)
fprintf('wiener mean noise peaks amp %f   mean signal amplitude %f \n',wmeannoiseamp,wmeansigamp)

if exist('calib','var')
    if isstruct(calib)
        hamp=hfdf_calib(calib,sour.f0,whou);
        fprintf('  h-amplitude %e\n',hamp)
        out.hamp=hamp;
    end
end

ptot=zeros(ntot,3);
ps=zeros(ns,3);
% pn=zeros(nn,3);

if level > 1
    ptot(:,1)=abs(ptout(6,:));
    ptot(:,2)=ptout(3,:);
    ptot(:,3)=ptout(4,:);
    color_points(ptot,0,{'Amplitude vs distance (wiener in color)' 'distance' 'amplitude'});

    ps(:,1)=abs(ptout(6,iis));
    ps(:,2)=ptout(3,iis);
    ps(:,3)=ptout(4,iis);
    color_points(ps,0,{'Signal amplitude vs distance (wiener in color)' 'distance' 'amplitude'});

    ptot(:,1)=ptout(1,:)-floor(ptout(1,1));
    ptot(:,2)=ptout(6,:);
    ptot(:,3)=ptout(3,:);
    color_points(ptot,0,{'distance vs time (amplitude in color)' 'time' 'distance'});
    % figure,plot(ptout(1,:),ptout(5,:),'.'),grid on

    ptot(:,2)=ptout(2,:)-floor(min(ptout(2,:)));
    color_points(ptot,0,{'frequency vs time (amplitude in color)' 'time' 'Hz'});
end

% Solar/Sidereal

[whsolad,ov,un,whsol,W,xt]=whist(mod(ptout(1,:),1)*24,ptout(4,:),12);
[whsolad1,ov,un,whsol1,W,xt1]=whist(mod(ptout(1,iis0),1)*24,ptout(4,iis0),12);

figure,stairs(xt-floor(xt(1)),whsol,':'), hold on,stairs(xt-floor(xt(1)),whsolad,'r'),grid on
title('Solar hour distribution (b normal, r wien)'),xlabel('days')

figure,stairs(xt1-floor(xt1(1)),whsol1,':'), hold on,stairs(xt1-floor(xt1(1)),whsolad1,'r'),grid on
title('Central data solar hour distribution (b normal, r wien)'),xlabel('days')

[whsidad,ov,un,whsid,W,xt]=whist(gmst(ptout(1,:)),ptout(4,:),12);
[whsidad1,ov,un,whsid1,W,xt1]=whist(gmst(ptout(1,iis0)),ptout(4,iis0),12);

figure,stairs(xt-floor(xt(1)),whsid,':'), hold on,stairs(xt-floor(xt(1)),whsidad,'r'),grid on
title('Sidereal hour distribution (b normal, r wien)'),xlabel('days')

figure,stairs(xt1-floor(xt1(1)),whsid1,':'), hold on,stairs(xt1-floor(xt1(1)),whsidad1,'r'),grid on
title('Central data sidereal hour distribution (b normal, r wien)'),xlabel('days')

% Spectral analysis

if level > 1
    out=full_peak_spec(ptout(1,iin),ptout(3,iin).*ptout(4,iin)); 
    out1=full_peak_spec(ptout(1,iis0),ptout(3,iis0).*ptout(4,iis0)); 
    % out2=full_peak_spec(ptout(1,iis1),ptout(3,iis1).*ptout(4,iis1)); 
    out2=out1;
    figure,plot(out.sp),title('Peak Spectrum (b noise, r signal)')
    % hold on,plot(out1.sp,'r'),plot(out2.sp,'g')

    clear ps
    ps(:,1)=gmst(ptout(1,iis0));
    ps(:,2)=ptout(6,iis0);
    ps(:,3)=ptout(3,iis0);
    color_points(ps,0,{'distance vs sid.time (amplitude in color)' 'sid.hours' 'distance'});

    hour=0.5:24;
    hs=hist(gmst(ptout(1,iis0)),hour)/ns;
    hn=hist(gmst(ptout(1,iin)),hour)/nn;
    figure,stairs(hour,hs*24,'r','LineWidth',2),grid on,hold on,stairs(hour,hn*24,'b')
    radpat=pss_sidpat(sour,ant);
    plot(radpat*4,'g')
    xlim([0 24]),xlabel('Sidereal hours')
end

% Noise check / out Doppler band

minfr=min(ptout(2,:));
maxfr=max(ptout(2,:));
frfr=maxfr-minfr;

ips=0;
indout=index*0;
indout(1)=1;

for i = 1:Nt
    fr=ptin(2,index(i):index(i+1)-1);
    ii=find(fr > minfr-frfr & fr <  maxfr+frfr);
    nii=length(ii);
    if nii > 0
        i1=ips+1;
        ips=ips+nii;%sprintf('%d %d \n',i,nii)
        i2=ips;
        ptout0(1:5,i1:i2)=ptin(:,index(i)-1+ii);
    end
    indout(i+1)=ips+1;
end

ptout0=ptout0(:,1:ips);
out.index0=indout;

% ii=find(ptin(2,:) >  minfr-frfr & ptin(2,:) <  maxfr+frfr);
% ptout0=ptin(:,ii);
ii1=find(ptout0(2,:) >  minfr & ptout0(2,:) <  maxfr);

tt=ptout0(1,:)-floor(ptout0(1,1));
figure,plot(tt,ptout0(2,:),'.'),grid on,title(['Original peaks ' lab])
hold on,plot(tt(ii1),ptout0(2,ii1),'r.'),xlabel('days'),ylabel('Hz')
xlim([0 max(ceil(tt))]),ylim([minfr-frfr maxfr+frfr])

ux1=0:max(tt);
% h1=hist(tt,ux1);
[WH1,ov,un,H1,W1]=whist(tt,ptout0(4,:),ux1);
figure,stairs(ux1,H1),grid on,title(['Original peaks time distribution ' lab]),xlabel('days')
hold on,stairs(ux1,WH1,'r')

ux2=unique(ptout0(2,:));
n2=floor(length(ux2)/3);
% h2=hist(ptout0(2,:),ux2);
[WH2,ov,un,H2,W2]=whist(ptout0(2,:),ptout0(4,:),ux2);
figure,stairs(ux2,H2),grid on,title(['Original peaks frequency distribution ' lab])
hold on,stairs(ux2,WH2,'r')
hold on,plot([minfr minfr],[min(H2) max(H2)],'g','LineWidth',2),xlabel('Hz')
plot([maxfr maxfr],[min(H2) max(H2)],'g','LineWidth',2),xlim([minfr-frfr maxfr+frfr])
plot([minfr-frfr minfr minfr maxfr maxfr maxfr+frfr],...
    [mean(H2(1:n2)) mean(H2(1:n2)) mean(H2(n2+1:2*n2)) mean(H2(n2+1:2*n2)) mean(H2(2*n2+1:3*n2)) mean(H2(2*n2+1:3*n2))],...
    'm:','LineWidth',3)

[h1 x1]=hist([H2(1:n2) H2(2*n2+1:3*n2)],20);
[h2 x2]=hist(H2(n2+1:2*n2),20);
figure,stairs(x1,h1/2),hold on,stairs(x2,h2,'r'),grid on
title('Histograms of frequency distribution (r in band, b out)')