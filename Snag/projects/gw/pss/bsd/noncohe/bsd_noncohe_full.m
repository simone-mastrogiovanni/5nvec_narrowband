function [noncohe,bsds]=bsd_noncohe_full(bsdsstr,band,direc,parin)
% non-coherent full analysis (not survey analysis)
%
%    noncohe=bsd_noncohe_full(bsdsstr,band,direc,check_sour)
%
%   bsdsstr       bsd search structure array (with addr,ant,runame  as for bsd_lego)
%                  or bsds cell array
%   band          frequency or band
%   direc         source direction
%   parin         parameters or check_sour  inj or known source (if present)
%        .ictf    = 1 time-frequency
%        .selfr   impose selfr (no selfr gui)
%        .icnodop no-doppler check
%        .sband
%        .nsid

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('parin','var')
    parin.ictf=1;
    parin.icnodop=1;
    parin.sband=[10 5];
    parin.nsid=24;
end

check_sour=parin;

if ~isfield(parin,'icnodop')
    parin.icnodop=1;
end
if ~isfield(parin,'ictf')
    parin.ictf=1;
end
if ~isfield(parin,'sband')
    parin.sband=[10 5];
end
if ~isfield(parin,'nsid')
    parin.nsid=24;
end

ic_check=0;
if isfield(check_sour,'f0')
    ic_check=1;
    parin.ictf=1;
    parin.icnodop=1;
    parin.sband=[10 5];
    parin.nsid=24;
end

ictf=parin.ictf;
sband=parin.sband;
nsid=parin.nsid;

if isfield(parin,'check_sour')
    ic_check=1;
    check_sour=parin.check_sour;
end

if isstruct(bsdsstr)
    if length(band) == 1
        band=band+[-0.5,0.5];
    end
    [bsds,pars]=bsd_crea_multi(bsdsstr,band);
else
    bsds=bsdsstr;
    n=length(bsds);
    clear bsdsstr
    for k = 1:n
        [~,pars1]=is_bsd(bsds{k});
        if k == 1
            tin=pars1.tin;
            tfi=pars1.tfi;
        else
            tin=min(tin,pars1.tin);
            tfi=max(tfi,pars1.tfi);
        end
        pars.ant{k}=pars1.ant;
    end

    pars.tin=tin;
    pars.tfi=tfi;
    pars.epoch=floor((tin+tfi)/2);
end

nant=length(bsds);

if length(band) == 1
    freq=band;
else
    freq(1)=(band(1)+band(2))/2;
    freq(2)=0;
    freq(3)=(band(2)-band(1))/2;
end
noncohe.sids=sid_sweep_multi(bsds,freq,direc,sband,nsid)
if parin.icnodop
    noncohe.sidsNoDop=sid_sweep_multi(bsds,freq,NoDop,sband,nsid);
end

if isfield(parin,'selfr')
    [noncohe.anas ]=ana_multi_sids(noncohe.sids,0);
    noncohe.selfr=parin.selfr;
else
    [noncohe.anas noncohe.selfr]=ana_multi_sids(noncohe.sids,ictf);
end

f0=mean(noncohe.selfr);

if ictf > 0
    for k = 1:nant
        sidstf{k}=sid_sweep_tf(bsds{k},'ligol','O2',f0,direc,sband,7,noncohe.selfr)
    end

    plot(sidstf{1}.sidsig)

    if ic_check
        pp=new_posfr(check_sour,pars.epoch);
        tims=(sidstf{1}.tims-pars.epoch)*86400;
        frteo=pp.f0+pp.df0*tims+pp.ddf0*tims.^2;
        hold on,plot(sidstf{1}.tims,frteo,'m')
        sidstf{1}.frteo=frteo;
    end

    plot(sidstf{2}.sidsig)
    if ic_check
        tims=(sidstf{2}.tims-pars.epoch)*86400;
        frteo=pp.f0+pp.df0*tims+pp.ddf0*tims.^2;
        hold on,plot(sidstf{2}.tims,frteo,'m')
        sidstf{2}.frteo=frteo;
    end

    noncohe.sidstf=sidstf;

    for k = 1:nant
        [HR.map,HR.pars]=fdf_rh_map(sidstf{k}.sidsig,1,0.5,0,0);
    end

    noncohe.HR=HR;

    plot(HR.map)
    title('H-R map')
end

fr=noncohe.sids{1}.fr;
for k = 1:nant
    ant=pars.ant{k};
    if parin.icnodop == 1
        figure,semilogy(fr,noncohe.sids{k}.sidsig,'.'),hold on,grid on,semilogy(fr,noncohe.sidsNoDop{k}.sidsig,'.')
        title(['sidsig ' ant ' (with NoDop)']),xlabel('Hz')
        figure,semilogy(fr,noncohe.sids{k}.sidnois,'.'),hold on,grid on,semilogy(fr,noncohe.sidsNoDop{k}.sidnois,'.')
        title(['sidnois ' ant ' (with NoDop)']),xlabel('Hz')
    else
        figure,semilogy(fr,noncohe.sids{k}.sidsig,'.'),grid on
        title(['sidsig ' ant]),xlabel('Hz')
        figure,semilogy(fr,noncohe.sids{k}.sidnois,'.'),grid on
        title(['sidnois ' ant]),xlabel('Hz')
    end
end

figure
aa=[ ];
for k = 1:nant
    ant=pars.ant{k};
    aa=[aa ant ' '];
    semilogy(fr,noncohe.sids{k}.sidsig,'.'),hold on,grid on
end
title(['sidsig of ' aa]),xlabel('Hz')