function done=crea_sid_sweep_db(addr,ant,runame,BAND,direc,sband,nsid)
% creates files collections like 
%
%     sids_GC_O2_0510_0520_L.mat
%
%    addr,ant,runame    standard inputs
%    BAND               bands (starting from the BAND(1) base to BAND(2) base)
%    direc              direction (should have a reasonable name: it will appear in the name of the files)
%    sband,nsid         see sid_sweep_ref_wrapper

% Snag Version 2.0 - July 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('nsid','var')
    nsid=-48;
end

iniband=floor(BAND(1)/10)*10+5;
finband=floor(BAND(2)/10)*10+6;

freq=iniband;
direcnam=direc.name;
switch ant
    case 'ligol'
        ANT='L';
    case 'ligoh'
        ANT='H';
    case 'virgo'
        ANT='V';
end

k=0;

while freq < finband
    k=k+1;
    freq0=floor(freq/10)*10;
    sids=sid_sweep_ref_wrapper(addr,ant,runame,freq,direc,sband,nsid);
    sids.runame=runame
    filnam=sprintf('sids_%s_%s_%04d_%04d_%s',direcnam,runame,freq0,freq0+10,ANT)
    save(filnam,'sids')
    done{k}=filnam;
    freq=freq+10;
end