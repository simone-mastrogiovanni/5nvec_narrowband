function [pm, basic_merge, hm_job]=merge_peakmap(pm1,pm2,out1,out2,basic_merge)
% merges peakmaps and does basic follow-up
%  
%  pm1,pm2      input peak maps
%  out1,out2    from veri_inv_hough
%  basic_merge   
%        .bi_1   basic_info 1  
%        .bi_2   basic_info 2
%        .sour   source parameters (fr,lam,bet,sd)
%        .usour  source uncertainty (ufr,ulam,ubet,usd)
%                creates patches in about ±ux with refined resolution (121 patches)
%
%  Out:
%     pm         merged peak map
%     basic_merge   basic_info for follow-up
%     hm_job     for the merged Hough

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

enhf=20;
enhsky=6;
enhsd=5;
lpatch=(2*enhsky+1);
patches=zeros(lpatch^2,2);

basic_merge.proc=basic_merge.bi_1.proc;
basic_merge.run=basic_merge.bi_1.run;
basic_merge.tim=[out1.tim out2.tim];
basic_merge.tim0=floor(min(basic_merge.tim));

pm=[pm1 pm2];
[n1 n2]=size(pm);
l1=length(out1.index0);
l2=length(out2.index0);
basic_merge.index=[out1.index0 out2.index0(2:l2)+out1.index0(l1)-1];
minfr=min(pm(2,:));
maxfr=max(pm(2,:));
basic_merge.velpos=[out1.velpos out2.velpos];
basic_merge.ntim=length(basic_merge.tim);

hm_job=struct();
basic_merge.merge_epoch=mean(pm(1,:));
basic_merge.epoch=basic_merge.merge_epoch;
basic_merge.coin_epoch=out1.sour_epoch;
basic_merge.epoch_1=out1.local_epoch;
basic_merge.epoch_2=out2.local_epoch;

Tobs=(max(pm(1,:))-min(pm(1)))*86400;
dnat=basic_merge.bi_1.run.fr.dnat;
fr=basic_merge.sour(1);
lam=basic_merge.sour(2);
bet=basic_merge.sour(3);
sd=basic_merge.sour(4);

Dfr=dnat;
ND=ceil(1.06e-4*fr/dnat); % "nominal Doppler band"
Dlam=180/(pi*(ND*cos(bet*pi/180)+1));
Dbet=180/(pi*(ND*abs(sin(bet*pi/180))+1));
Dsd=max(basic_merge.bi_1.run.sd.dnat,basic_merge.bi_1.run.sd.dnat);

basic_merge.Dsour=[Dfr,Dlam,Dbet,Dsd];
basic_merge.ND=ND;

dfr=Dfr/enhf;
dlam=Dlam/enhsky;
dbet=Dbet/enhsky;
dsd=(2*dnat/Tobs)/enhsd;

basic_merge.dsour=[dfr,dlam,dbet,dsd];

hm_job.fr=[minfr-5*Dfr Dfr enhf maxfr+5*Dfr];
hm_job.sd=[sd-2*Dsd dsd ceil(4*Dsd/dsd)];

lams=lam+(-enhsky:enhsky)*dlam;
ii=0;

for i = -enhsky:enhsky
    bet0=bet+i*dbet;
    bets(i+enhsky+1)=bet0;
    patches(ii+1:ii+lpatch,1)=lams;
    patches(ii+1:ii+lpatch,2)=bet0;
    ii=ii+lpatch;
end

n1sky=enhsky*2+1;
nfr=round((hm_job.fr(4)-hm_job.fr(1))/dfr);

fprintf('\n       Grid (N,min,max,step - nat) \n')
fprintf('frequency: %d %.5f %.5f %e    - nat = %e\n',nfr,hm_job.fr(1),hm_job.fr(4),dfr,Dfr);
fprintf('   lambda: %d %.2f %.2f %.2f   - nat = %.2f\n',n1sky,lams(1),lams(n1sky),dlam,Dlam);
fprintf('     beta: %d %.2f %.2f %.2f   - nat = %.2f\n',n1sky,bets(1),bets(n1sky),dbet,Dbet);
fprintf('spin-down: %d %.3e %.3e %.3e    - nat = %e\n',hm_job.sd(3),hm_job.sd(1),hm_job.sd(1)+dsd*hm_job.sd(3),dsd,Dsd);


basic_merge.patches=patches;
basic_merge.mode.peak_mode=2;
basic_merge.mode.hm_job.frenh=enhf;
basic_merge.frin=hm_job.fr(1);
basic_merge.frfi=hm_job.fr(4);