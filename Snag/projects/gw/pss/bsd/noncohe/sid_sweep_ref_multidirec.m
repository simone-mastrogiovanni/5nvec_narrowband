function [sidsref,outpars]=sid_sweep_ref_multidirec(addr,ant,runame,freq,direcs,sband,check_sour)
% refinement of sid_sweep candidates on many sbands
%
%   [sidsref,outpars]=sid_sweep_ref_multidirec(addr,ant,runame,freq,direc,sband,check_sour)
%
%   addr,ant,runame  as for bsd_lego
%           if addr is a bsd, use it
%           if ant is a table, use it
%   freq    candidate frequency;
%            if 2-dim freq(2), spin-down
%            if 3-dim freq(3) is the semiband; def semiband 0.5 Hz
%   direcs  cell array with direction structures
%   sband   search band (in units of 1/SD; typically 10)
%             if present sband(2) = interlacing delay (in 1/SD)
%             sband(3) = enlargement factor (def enl=10, min recommended 5)
%   check_sour  if present, for checking

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if exist('check_sour','var')
    ic_check=1;
else
    ic_check=0;
end

outpars.direcs=direcs;

ndir=length(direcs);

for k = 1:ndir
    direc1=direcs{k};
    sidsref{k}=sid_sweep_ref(addr,ant,runame,freq,direc1,sband);
    if k == 1
        addr=sidsref{1}.bsd_out;
    end
end

figure
for k = 1:ndir
    sn=sidsref{k}.sidsig./sidsref{k}.sidnois;
    semilogy(sidsref{k}.fr,sn),grid on,hold on
    pause(1)
    [M,I]=max(sn);
    ii=find(~isnan(sn));
    sn=sn(ii);
    outpars.sn_frmax(k)=sidsref{k}.fr(I);
    outpars.sn_max(k)=M;
    rs=robstat(sn,0.67);
    msn=rs(1);
    ssn=rs(2);
    outpars.sn_mean(k)=msn;
    outpars.sn_std(k)=ssn;
    outpars.sn_snr(k)=(M-outpars.sn_mean(k))/outpars.sn_std(k);
    Lsn=log10(sn);
    outpars.Lsn_max(k)=log10(M);
    outpars.Lsn_mean(k)=mean(Lsn);
    outpars.Lsn_std(k)=std(Lsn);
    outpars.Lsn_snr(k)=(outpars.Lsn_max(k)-outpars.Lsn_mean(k))/outpars.Lsn_std(k);
end
title('Robust filter')
xlabel('Hz')
if ic_check
    plot_lines(check_sour.f0,sn)
end

figure
for k = 1:ndir
    ss=sidsref{k}.sidsig;
    semilogy(sidsref{k}.fr,ss),grid on,hold on
    pause(1)
    [M,I]=max(ss);
    outpars.ss_frmax(k)=sidsref{k}.fr(I);
    outpars.ss_max(k)=M;
    rs=robstat(ss,0.67);
    mss=rs(1);
    sss=rs(2);
    outpars.ss_mean(k)=mss;
    outpars.ss_std(k)=sss;
    outpars.ss_snr(k)=(M-outpars.ss_mean(k))/outpars.ss_std(k);
    ii=find(ss > 0);
    ss=ss(ii);
    Lss=log10(ss);
    outpars.Lss_max(k)=log10(M);
    outpars.Lss_mean(k)=mean(Lss);
    outpars.Lss_std(k)=std(Lss);
    outpars.Lss_snr(k)=(outpars.Lss_max(k)-outpars.Lss_mean(k))/outpars.Lss_std(k);
end
title('High sensitivity filter')
xlabel('Hz')
if ic_check
    plot_lines(check_sour.f0,ss)
end

[M,outpars.Isn]=max(outpars.sn_max);
[M,outpars.Iss]=max(outpars.ss_snr);