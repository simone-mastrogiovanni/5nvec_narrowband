function psc=psc_anacoin(file)
%PSC_ANACOIN  analizes psc level-2 coincidence file
%
%   file        coincidence file
%
%   psc         psc structure
%    .level     level (1 candidate, 2 coincidence candidate, n n-groups
%                coincidence candidates)
%    .width     normalized coincidence width
%
%    .sear      search structure
%      .diffr   frequency difference
%      .diflam  lambda difference
%      .difbet  beta difference
%      .sd1     sd1 difference
%
%    .found   found coincidences
%    .nc0     level-0 coincidences (comparisons)
%    .nc1     level-1 coincidences (after frequency selection)
%    .nc2     level-2 coincidences
%    .nc3     level-3 coincidences
%    .expect  expected coincidences
%      .found
%      .nc0
%      .nc1
%      .nc2
%      .nc3
%
%    .N(n)      number of candidates
%    .initim(n) initial time
%    .fftlen(n) fft length
%
%    .dfr(n)    frequency quanta
%    .dlam(n)   lambda quanta
%    .dbet(n)   beta quanta
%    .dsd1(n)   sd1 quanta
%    .dcr(n)    cr quanta
%    .dmh(n)    mh quanta
%    .dh(n)     h quanta
%
%    .nfr(n)    frequencies numbers
%    .nlam(n)   lambdas numbers
%    .nbet(n)   betas numbers
%    .nsd1(n)   sd1s numbers
%
%    .fr(:,n)   frequencies
%    .lam(:,n)  lambdas
%    .bet(:,n)  betas
%    .sd1(:,n)  sd1s
%    .cr(:,n)   crs (critical ratios)
%    .mh(:,n)   mhs (mean Hough)
%    .h(:,n)    hs (h amplitudes)

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file')
    file=selfile('');
end

fid=fopen(file,'r');

fgetl(fid);
fgetl(fid);
fgetl(fid);
maxfr=textscan(fid,'%s %f',1);
psc.maxfr=maxfr{2};
sear=textscan(fid,'%s',1);
sear=textscan(fid,'%f',4);
sear=sear{1};
psc.sear.diffr=sear(1);
psc.sear.diflam=sear(2);
psc.sear.difbet=sear(3);
psc.sear.difsd1=sear(4);

fgetl(fid);
fgetl(fid);
fgetl(fid);
textscan(fid,'%s',1);
infi=textscan(fid,'%f',2);
infi=infi{1};
psc.initim(1)=infi(1);
psc.fftlen(1)=infi(2);

textscan(fid,'%s',1);
dd=textscan(fid,'%f',7);
dd=dd{1};
psc.dfr(1)=dd(1);
psc.dlam(1)=dd(2);
psc.dbet(1)=dd(3);
psc.dsd1(1)=dd(4);
psc.dcr(1)=dd(5);
psc.dmh(1)=dd(6);
psc.dh(1)=dd(7);

textscan(fid,'%s',1);
nn=textscan(fid,'%f',4);
nn=nn{1};
psc.nfr(1)=nn(1);
psc.nlam(1)=nn(2);
psc.nbet(1)=nn(3);
psc.nsd1(1)=nn(4);

fgetl(fid);
fgetl(fid);
fgetl(fid);
textscan(fid,'%s',1);
infi=textscan(fid,'%f',2);
infi=infi{1};
psc.initim(2)=infi(1);
psc.fftlen(2)=infi(2);

textscan(fid,'%s',1);
dd=textscan(fid,'%f',7);
dd=dd{1};
psc.dfr=dd(1);
psc.dlam(2)=dd(2);
psc.dbet(2)=dd(3);
psc.dsd1(2)=dd(4);
psc.dcr(2)=dd(5);
psc.dmh(2)=dd(6);
psc.dh(2)=dd(7);

textscan(fid,'%s',1);
nn=textscan(fid,'%f',4);
nn=nn{1};
psc.nfr(2)=nn(1);
psc.nlam(2)=nn(2);
psc.nbet(2)=nn(3);
psc.nsd1(2)=nn(4);

fgetl(fid);
fgetl(fid);
A=textscan(fid,'%d -> %f <-> %f %f <-> %f %f <-> %f %f <-> %f %f <-> %f %f <-> %f %f <-> %f');
psc.fr(:,1)=A{2};
psc.fr(:,2)=A{3};
psc.lam(:,1)=A{4};
psc.lam(:,2)=A{5};
psc.bet(:,1)=A{6};
psc.bet(:,2)=A{7};
psc.sd1(:,1)=A{8};
psc.sd1(:,2)=A{9};
psc.cr(:,1)=A{10};
psc.cr(:,2)=A{11};
psc.mh(:,1)=A{12};
psc.mh(:,2)=A{13};
psc.h(:,1)=A{14};
psc.h(:,2)=A{15};

A=textscan(fid,'%s %s %d %s %d %s',1);
psc.N(1)=A{3};
psc.N(2)=A{5};

A=textscan(fid,'%d %s %d %s %s %d %s %s %d %s %s %d',1);
psc.nc0=A{1};
psc.nc1=A{3};
psc.nc2=A{6};
psc.nc3=A{9};

fclose(fid);

[n,iz]=size(psc.fr);
psc.found=n;

N1=double(psc.N(1));
N2=double(psc.N(2));

N=N1*N2;

% ridfr=psc.sear.diffr*(2/psc.fftlen(1)+2/psc.fftlen(2))/2;
% ridlam=psc.sear.diflam*(1/psc.nlam(1)+1/psc.nlam(2))/2;
% ridbet=psc.sear.difbet*(1/psc.nbet(1)+1/psc.nbet(2))/2;
% ridsd1=psc.sear.difsd1*(1/psc.nsd1(1)+1/psc.nsd1(2))/2;
% rid=ridfr*ridlam*ridbet*ridsd1;
% expect=N*rid;
% psc.expect=expect;
% 
% ratio=psc.expect/psc.found

lfr1=2*N1/psc.fftlen(1)
lfr2=2*N2/psc.fftlen(2)
lfr=lfr1*lfr2*psc.sear.diffr/2
psc.expect.n1=lfr1*N2*psc.sear.diffr/2