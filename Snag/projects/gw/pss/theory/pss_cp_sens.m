function pss_comp=pss_cp_sens(pss_comp)
%PSS_CP_SENS  evaluation of sensitivity and computing power needed
%
%  for an example, use pss_comp_rep
%
%       pss_comp=pss_cp_sens(pss_comp)
%
%   pss_comp.tobs       observation time (days)
%   pss_comp.tcoh       time length of coherent analysis (s)
%   pss_comp.nu0        source frequency (Hz)
%   pss_comp.maxnu0     max source frequency
%   pss_comp.sdtau      source spin-down tau (years)
%   pss_comp.minsdtau   min source spin-down tau
%   pss_comp.noiseh     unilateral spectral density noise h (sqr(Hz)^-1)
%   pss_comp.frres      frequency relative resolution
%   pss_comp.skyres     sky relative resolution
%   pss_comp.sdres      sd relative resolution
%   pss_comp.houghkfl   basic cost for hough transform
%   pss_comp.cohkfl     basic cost for coherent step
%
%   pss_comp.maxsdHzday max source spin-down f^dot (per day)
%   pss_comp.maxsdHzs   max source spin-down f^dot (per second)
%   pss_comp.ncoh       number of coherent pieces (not interlaced)
%   pss_comp.hiernomloss  hierarchical nominal loss
%   pss_comp.sfdbtlen   maximum time length of SFDB ffts (lat=45)
%   pss_comp.ncohsfdb   sfdb max length ncoh
%   pss_comp.sfdbcp     sfdb computing cost (no quality & c)
%
%   pss_comp.hodnomsens optimal detection nominal sensitivity
%   pss_comp.hodsens1G  optimal detector sensitivity for 10^9 candidates
%   pss_comp.hnomsens   nominal sensitivity
%   pss_comp.redcoef    reduction coefficient to have 1G candidates
%   pss_comp.hsens1G    sensitivity for 10^9 candidates
%   pss_comp.hsfdbsens1G  sensitivity for 10^9 candidates for sfdb max len
%   pss_comp.odnfr      optimal detection number of frequency bins
%   pss_comp.odnDB          "        "    parameter
%   pss_comp.odnsky         "        "    parameter
%   pss_comp.odnsd(k)       "        "    parameter
%   pss_comp.odNsd          "        "    parameter
%   pss_comp.odntot         "        "    parameter
%   pss_comp.nfr        number of frequency bins
%   pss_comp.nDB        number of frequency bins in the Doppler band
%   pss_comp.nsky       number of points in the sky
%   pss_comp.Nsd        number of spin-down parameters (order)
%   pss_comp.nsd(k)     number of points for the k-th sd parameter
%   pss_comp.ntot       total number of points in the parameter spacenumber
%   pss_comp.dsd(k)     sd k-par step
%   pss_comp.pixann     number of pixel for one annulus
%   pss_comp.houghbo    hough map basic operations
%   pss_comp.houghcp    hough map computing power (Gflops)
%   pss_comp.nskypatch  number of sky patches
%   pss_comp.nsdpatch   number of sd patches
%   pss_comp.npatch     number of patches
%   pss_comp.nmappatch  number of map patches
%   pss_comp.cohcp      coherent step cost
%
%   pss_comp.hfdf            hfdf sub-structure (many data are for the
%                               first piece (higher frequency)
%     uses tobs  
%   pss_comp.hfdf.tcoh       hfdf coherent step duration  
%   pss_comp.hfdf.tcoh       number of coherent pieces
%   pss_comp.hfdf.Nsky       number of optimized sky points
%   pss_comp.hfdf.maxNhfdf   maximum Hough map array dimension
%   pss_comp.hfdf.Nhfdf      Hough map array dimension
%   pss_comp.hfdf.maxfr      maximum frequency 
%   pss_comp.hfdf.nf         number of frequency bins
%   pss_comp.hfdf.dfr        frequency bin width
%   pss_comp.hfdf.nsd        number of spin-down values
%   pss_comp.hfdf.ncomp      number of basic operations max band (sums)
%   pss_comp.hfdf.band       frequency band of the pieces
%   pss_comp.hfdf.nband      number of bands
%   pss_comp.hfdf.ncomptot   number of basic operations for all bands
%   pss_comp.hfdf.npointtot  number of points in the parameter space

% Version 2.0 - December 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

%------- conversions -----------

pss_comp.maxsdHzday=pss_comp.maxnu0./(365.25*pss_comp.minsdtau);
pss_comp.maxsdHzs=pss_comp.maxsdHzday/86400;

%------- optimal detection ----------

pss_comp.odnfr=pss_comp.tobs*86400*pss_comp.maxnu0*pss_comp.frres;
pss_comp.odnDB=pss_comp.odnfr*1.e-4;
pss_comp.odnsky=4*pi*pss_comp.odnDB^2;
pss_comp.odnsd=0;
k=0;
n0=2*pss_comp.odnfr;
kred=pss_comp.tobs/(365.25*pss_comp.minsdtau);
nk=n0;
while (nk*kred > 1) && k < 6
    k=k+1;
    nk=nk*kred;
    pss_comp.odnsd(k)=ceil(nk);
end
pss_comp.odNsd=k;
pss_comp.odntot=pss_comp.odnfr*pss_comp.odnsky*prod(pss_comp.odnsd);
pss_comp.hodnomsens=pss_comp.noiseh*sqrt(2/(86400*pss_comp.tobs));
pss_comp.hodsens1G=pss_comp.hodnomsens.*redcoef_gausthresh(pss_comp.odntot,1.e9).^2;

%---------- hough ----------------

pss_comp.ncoh=pss_comp.tobs*86400./pss_comp.tcoh;
pss_comp.hiernomloss=pss_comp.ncoh.^0.25;

pss_comp.hnomsens=pss_comp.hodnomsens*pss_comp.hiernomloss;

pss_comp.nfr=pss_comp.tcoh*pss_comp.maxnu0*pss_comp.frres;
pss_comp.nDB=pss_comp.nfr*1.e-4;
pss_comp.nsky=4*pi*pss_comp.nDB.^2;

n0=2*pss_comp.nfr;
kred=pss_comp.tobs/(365.25*pss_comp.minsdtau);
if size(pss_comp.tcoh) == 1
    pss_comp.nsd=0;
    k=0;
    nk=n0;
    while (nk*kred > 1) && k < 6
        k=k+1;
        nk=nk*kred;
        pss_comp.nsd(k)=ceil(nk);
    end
    pss_comp.Nsd=k;
    totsd=prod(pss_comp.nsd);
else
    totsd=1;
    for i = 1:4
        nk=ceil(n0*kred.^i);
        totsd=totsd.*nk;
    end
end

pss_comp.ntot=pss_comp.nfr.*pss_comp.nsky.*totsd;

pss_comp.pixann=4*pi*pss_comp.nDB;
pss_comp.houghbo=pss_comp.nfr.*totsd.*pss_comp.nDB.*pss_comp.ncoh.*pss_comp.pixann/12;
pss_comp.houghcp=2*10^-9*pss_comp.houghbo.*pss_comp.houghkfl./(pss_comp.tobs*86400);

pss_comp.redcoef=redcoef_gausthresh(pss_comp.ntot,1.e9);
pss_comp.hsens1G=pss_comp.hnomsens.*pss_comp.redcoef;


%---------- hfdf ----------------

pss_comp.hfdf.nf=floor(pss_comp.hfdf.maxNhfdf/pss_comp.hfdf.nsd);
pss_comp.hfdf.Nhfdf=pss_comp.hfdf.nf*pss_comp.hfdf.nsd;
npeaks=pss_comp.hfdf.nf/12;
pss_comp.hfdf.dfr=1/pss_comp.hfdf.tcoh;
pss_comp.hfdf.Nsky=2*pi*(pss_comp.hfdf.maxfr*0.0001/pss_comp.hfdf.dfr)^2;
pss_comp.hfdf.ncoh=pss_comp.tobs*86400/pss_comp.hfdf.tcoh;
pss_comp.hfdf.ncomp=pss_comp.hfdf.Nsky*npeaks*pss_comp.hfdf.nsd*pss_comp.hfdf.ncoh;
pss_comp.hfdf.band=pss_comp.hfdf.nf*pss_comp.hfdf.dfr;

cost=pss_comp.hfdf.ncomp;
pss_comp.hfdf.ncomptot=cost;
nband=ceil(pss_comp.hfdf.maxfr-pss_comp.hfdf.minfr)/pss_comp.hfdf.band
npoint=pss_comp.hfdf.Nsky*pss_comp.hfdf.nsd*pss_comp.hfdf.nf;
facttot=1
for i = 1:nband-1
    fr=pss_comp.hfdf.maxfr-i*pss_comp.hfdf.band;
    fact=(fr/pss_comp.hfdf.maxfr)^2;
    facttot=facttot+fact;
    pss_comp.hfdf.ncomptot=pss_comp.hfdf.ncomptot+cost*fact;
end
    
pss_comp.hfdf.ncomptot=pss_comp.hfdf.ncomp*facttot;
pss_comp.hfdf.npointtot=npoint*facttot;


%------ sfdb limit --------------

pss_comp.sfdbtlen=sqrt(2.99e8./(2*pss_comp.maxnu0*0.023991));
pss_comp.ncohsfdb=pss_comp.tobs*86400./pss_comp.sfdbtlen;
lfft=pss_comp.sfdbtlen*2*pss_comp.maxnu0;
pss_comp.sfdbcp=10^-9*pss_comp.ncohsfdb*lfft*10*log2(lfft)*2/(pss_comp.tobs*86400);

pss_comp.hsfdbnomsens=pss_comp.hodnomsens*pss_comp.ncohsfdb.^0.25;

sfdbnfr=pss_comp.sfdbtlen*pss_comp.maxnu0*pss_comp.frres;
sfdbnDB=sfdbnfr*1.e-4;
sfdbnsky=4*pi*sfdbnDB.^2;

sfdbtotsd=1;
for i = 1:4
    nk=ceil(n0*kred.^i);
    sfdbtotsd=sfdbtotsd.*nk;
end
    
pss_comp.sfdbntot=sfdbtotsd*sfdbnfr*sfdbnsky;
pss_comp.hsfdbsens1G=pss_comp.hsfdbnomsens.*redcoef_gausthresh(pss_comp.sfdbntot,1.e9);

%------- coherent analysis --------

pss_comp.nskypatch=ceil(pss_comp.tcoh/pss_comp.sfdbtlen).^2;
pss_comp.nsdpatch=ceil(pss_comp.maxsdHzs.*pss_comp.tcoh.^2);
pss_comp.npatch=pss_comp.nskypatch.*pss_comp.nsdpatch;
pss_comp.nmappatch=4*pi*(pss_comp.tcoh*pss_comp.maxnu0*340/2.99e8).^2;

if pss_comp.npatch <= 1
    pss_comp.cohcp=pss_comp.sfdbcp;
else
    pss_comp.cohcp=pss_comp.sfdbcp*(1+(pss_comp.npatch-1)*sfdbnDB*pss_comp.cohkfl);
end
