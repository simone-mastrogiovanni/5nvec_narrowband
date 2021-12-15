function crea_pssfakecand(dircand,N,band,pss_cand_head)
%CREA_PSSFAKECAND  creates a fake candidate data base
%
%  dir             directory where the database sould be created
%  N               total number of events
%  band            band (1,2,3 or 4)
%  pss_cand_head   pss_cand file header (and simulation pars); see default

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('dircand')
    dircand='';
end

snag_local_symbols;

if ~exist('N')
    N=1000000;
end

if ~exist('band')
    band=1;
end

if ~exist('pss_cand_head')
    pss_cand_head.initim=0;
    pss_cand_head.st=0.00025;
    pss_cand_head.fftlen=2^22;
    pss_cand_head.inifr=0;
    pss_cand_head.dlam=0.2290076;
    pss_cand_head.dbet=0.2290076;
    pss_cand_head.dsd1=1.5e-9;
    pss_cand_head.dcr=0.01;
    pss_cand_head.dmh=0.01;
    pss_cand_head.dh=1.e-25;
    pss_cand_head.prot=1;
    pss_cand_head.capt=['fake candidate created at ' datestr(now)];
    pss_cand_head.simu.maxsd=pss_cand_head.dsd1*1000;
    pss_cand_head.simu.maxh=pss_cand_head.dh*100;
end

switch band
    case 1
        nfreq=2000;
    case 2
        nfreq=500;
    case 3
        nfreq=125;
    case 4
        nfreq=31;
end

dfr=1/(pss_cand_head.st*pss_cand_head.fftlen);
nlam=round(360/pss_cand_head.dlam);
nbet=round(180/pss_cand_head.dbet);
nsd1=200;
ncr=500;
nmh=100;
nh=100;
nfr=ceil(1/dfr);
n1=ceil(N/nfreq);
dir1='0000';
dir2='00';
set_random;
A=zeros(n1,8);

for i = 1:nfreq
    pss_cand_head.inifr=(i-1)/dfr;
    r=rand(7,n1);
    vdir1=floor((i-1)/100);
    vdir2=floor((i-vdir1*100-1)/10);
    vdir3=floor(i-vdir1*100-vdir2*10-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
%     disp([dir1 dirsep dir2 dirsep dir3])

    frs1=floor((basfr+10*r(1,:))*1000000);
    frs2=floor(frs1/65536);
    frs1=floor(frs1-frs2*65536);

    A(:,1)=frs1;
    A(:,2)=frs2; 
    
    A(:,3)=floor(nlam*r(2,:));
    A(:,4)=floor(nbet*r(3,:));
    A(:,5)=floor(nsd1*r(4,:));
    A(:,6)=floor(ncr*r(5,:));
    A(:,7)=floor(nmh*r(6,:));
    A(:,8)=floor(nh*r(7,:));
    A=sortrows(A);
    file=sprintf('pss_cand_%04d.cand',i-1);
    filtot=[dircand dir1 dirsep dir2 dirsep file];
    fid=fopen(filtot,'w');
    fwrite(fid,pss_cand_head.prot,'int32');
    fprintf(fid,'%128s',pss_cand_head.capt);
    fwrite(fid,pss_cand_head.initim,'float64');
    fwrite(fid,pss_cand_head.st,'float64');
    fwrite(fid,pss_cand_head.fftlen,'int64');
    fwrite(fid,pss_cand_head.inifr,'int64');
    fwrite(fid,pss_cand_head.dlam,'float32');
    fwrite(fid,pss_cand_head.dbet,'float32');
    fwrite(fid,pss_cand_head.dsd1,'float32');
    fwrite(fid,pss_cand_head.dcr,'float32');
    fwrite(fid,pss_cand_head.dmh,'float32');
    fwrite(fid,pss_cand_head.dh,'float32');
    
    fwrite(fid,A','uint16');
    
    fclose(fid);
end
