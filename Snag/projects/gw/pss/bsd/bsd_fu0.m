function out=bsd_fu0(in,cands,lenini,enh)
% bsd base follow-up
%
%    out=bsd_fu(in,candstr,lenini)
%
%   in           input bsd (not corrected, possibly small band)
%   candstr      candidate or direct parameters
%         .lam   right ascenson (deg)
%         .bet   declination
%         .fr    frequency and derivative
%         .ulam  uncertainty on right ascenson (deg)
%         .ubet  uncertainty on declination
%         .uf    uncertainty on frequency and derivative
%   lenini       length of the fft used for candidate or to define uncertainty
%
%    cand(9,N)   [fr lam bet sd amp CR dlam dbet typ]

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[n1,n2]=size(cands);
if ~exist('enh','var')
    enh=20;
end

cont=ccont_gd(in);
dt=dx_gd(in);

for i = 1:n2
    candstr.lam=cands(2,i);
    candstr.bet=cands(3,i);
    candstr.fr=[cands(1,i),cands(4,i)];
    candstr.ulam=cands(7,i);
    candstr.ubet=cands(8,i);
    candstr.uf=cans(2,i);
    
    bsdcor=bsd_dopp_sd(in,candstr);
    
    parin.candstr=candstr;
    par=bsd_par(bsdcor,parin);
    lenini1=lenini*enh;

    tfstr=bsd_peakmap(bsdcor,lenini1);

    tfstr.dir_par=par; %save('tfstrfil','tfstr')
    typ=[3,1];

    proc_info.epoch=cont.t0+n*dt/(2*86400);
    proc_info.hm.fr(1)=cont.inifr;
    proc_info.hm.fr(2)=1/par.tfft;
    proc_info.hm.fr(3)=10;
    proc_info.hm.fr(4)=cont.inifr+cont.bandw;
    proc_info.hm.oper='noadapt';
    proc_info.hm.sd(1)=-par.dsd0*10;
    proc_info.hm.sd(2)=par.dsd0;
    proc_info.hm.sd(3)=12;

    proc_info.peak_mode=2;

    job_info.type='direct';
    job_info.patch(1)=direct.a;
    job_info.patch(2)=direct.d;
    job_info.patch(3:5)=0;  % DA SISTEMARE

    kcand=300;

    [hmap,job_info,checkE]=bsd_hough(typ,tfstr.pt.peaks,proc_info,job_info);

    check.hmap=hmap;
    check.job_info=job_info;
    toc

    [cand,job_info,checkF]=bsd_cand(hmap,proc_info,job_info,kcand);

    check.cand=cand;
    check.job_info=job_info;
end
