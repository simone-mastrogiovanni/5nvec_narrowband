function [pout,job_info,checkD]=bsd_patch(pin,job_info)
% creates and doppler-corrects a peak table, computing the wiener weights
%                  with radiation pattern
%
%    [pout,job_info,checkD]=bsd_patch(pin,proc_info,job_info,patch)
%
%   pin         input peak table as created by crea_peak_table [5 N] 
%   proc_info   procedure info structure
%   job_info    job info structure
%   patch       sky patch as ecliptical [long lat]
%
%   pout        output peak table [5 N] (t fr amp wien-nois wien-nois_radpat)
%   job_info    job info structure
%   checkD      service structure for test and debug

% Snag Version 2.0 - March 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
checkD=struct();

patch=job_info.patch;

job_info.proc.D_bsd_patch.vers='170230';
job_info.proc.D_bsd_patch.patch=patch;
job_info.proc.D_bsd_patch.tim=datestr(now);

pout=pin;

% % runstr=basic_info.run;
% % index=basic_info.index;
% % vel=basic_info.velpos;

[alpha,delta]=astro_coord('ecl','equ',patch(1),patch(2));
job_info.equpatch=[alpha,delta];
% r=astro2rect([alpha,delta],0);
% v=vel(1:3,:);
% Nt=basic_info.ntim;
% v1=zeros(1,Nt);

% % for i = 1:Nt
% %     v1(i)=dot(v(:,i),r);
% % end

% v1=r*v;  % DA BOLOGNA

sidh=gmst(pin(1,:));
sour.a=alpha;
sour.d=delta;
sour.eta=1;
sour.psi=0;
sidpat=pss_sidpat_psi(sour,job_info.ant,120,0);
radpat=gd_interp(sidpat,sidh);
job_info.sidpat=sidpat*2;
radpat=radpat.*pin(4,:);
radpat=radpat/mean(radpat);

pout(5,:)=radpat;

% % for i = 1:Nt
% %     fr=pin(2,index(i):index(i+1)-1);
% %     dfr=fr*v1(i);
% %     pout(2,index(i):index(i+1)-1)=fr-dfr;
% % end

% for i = 1:Nt
%     fr=pin(2,index(i):index(i+1)-1);
%     pout(2,index(i):index(i+1)-1)=fr./(1+v1(i));
% end

% checkD.dopcor=v1;
job_info.proc.D_hfdf_patch.duration=toc;