function runstr=O1LL(k)
% run structure
%
%   k   particular sets

if ~exist('k','var')
    k=1;
end
%%GPS times 1126621184 - 
%gps_ini=1126621184
%str='2015-09-18';
%runstr.ini=s2mjd(str);
%runstr.ini=gps2mjd(gps_ini);
runstr.ini=57283.5968402;
runstr.fin=57373.5968402;  %90 days.
runstr.ant=ligol;
runstr.run=sprintf('O1LL_%02d',k);
DNU=16384;
RUN_DUR_s=4*30*86400;
DMIN=1.0E-8;
switch k
    case 1
        TFFT=8192;
        BAND=256;   %fmax 128
        SUBSAM=DNU/BAND;  %64
        runstr.capt='01 2015  [0-128] Hz';
        runstr.epoch=57328.5968402;  %45 days after beginning ?
        runstr.st=1/BAND;
        runstr.fr.dnat=1/TFFT;
        runstr.sd.dnat=1/TFFT/RUN_DUR_s;  %1.5698E-11
        howmany=ceil(DMIN/runstr.sd.dnat);
        runstr.sd.min=-howmany*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;  %2 bin positivi
        runstr.fft.len=TFFT*DNU/SUBSAM;   %2097152
        runstr.fft.n=ceil(RUN_DUR_s/TFFT*2);
        runstr.anaband=[10 127 1];
    case 2
        TFFT=4096;
        BAND=1024;   %2*fmax. fmax 512
        SUBSAM=DNU/BAND;  %16
        runstr.capt='O1 2015  [0-512] Hz';
        runstr.epoch=57328.5968402;  %45 days after beginning ?
        runstr.st=1/BAND;
        runstr.fr.dnat=1/TFFT;
        runstr.sd.dnat=1/TFFT/RUN_DUR_s;
        howmany=ceil(DMIN/runstr.sd.dnat);
        runstr.sd.min=-howmany*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;  %2 bin positivi
        runstr.fft.len=TFFT*DNU/SUBSAM;   
        runstr.fft.n=ceil(RUN_DUR_s/TFFT*2);
        runstr.anaband=[127 507 5];
    case 3
        TFFT=2048;
        BAND=2048;   %fmax 1024
        SUBSAM=DNU/BAND; %8
        runstr.capt='O1 2015  [0-1024] Hz';
        runstr.epoch=57328.5968402;  %45 days after beginning ?
        runstr.st=1/BAND;
        runstr.fr.dnat=1/TFFT;
        runstr.sd.dnat=1/TFFT/RUN_DUR_s;  %1.5698E-11
        howmany=ceil(DMIN/runstr.sd.dnat);
        runstr.sd.min=-howmany*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;  %2 bin positivi
        runstr.fft.len=TFFT*DNU/SUBSAM;   
        runstr.fft.n=ceil(RUN_DUR_s/TFFT*2);
        runstr.anaband=[509 1019 5];
    case 4
        TFFT=1024;
        BAND=4096;   %fmax 2048 
        SUBSAM=DNU/BAND;  %4
        runstr.capt='O1 2015  [0-2048] Hz';
        runstr.epoch=57328.5968402;  %45 days after beginning ?
        runstr.st=1/BAND;
        runstr.fr.dnat=1/TFFT;
        runstr.sd.dnat=1/TFFT/RUN_DUR_s;
        howmany=ceil(DMIN/runstr.sd.dnat);
        runstr.sd.min=-howmany*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;  %2 bin positivi
        runstr.fft.len=TFFT*DNU/SUBSAM;   %4194304
        runstr.fft.n=ceil(RUN_DUR_s/TFFT*2);
        runstr.anaband=[1023 2043 5];
    case 23
        DMIN=-2*10^-9;
        TFFT=2048;
        BAND=2048;   %fmax 1024
        SUBSAM=DNU/BAND; %8
        runstr.capt='O1 2015  [0-1024] Hz';
        runstr.epoch=57328.5968402;  %45 days after beginning ?
        runstr.st=1/BAND;
        runstr.fr.dnat=1/TFFT;
        runstr.sd.dnat=1/TFFT/RUN_DUR_s;  %1.5698E-11
        howmany=ceil(DMIN/runstr.sd.dnat);
        runstr.sd.min=-howmany*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;  %2 bin positivi
        runstr.fft.len=TFFT*DNU/SUBSAM;   
        runstr.fft.n=ceil(RUN_DUR_s/TFFT*2);
        runstr.anaband=[124 1019 5];
   
end

%%runstr.hw_inj={pulsar_3,pulsar_5,pulsar_10};  %modify/correct
runstr.hw_inj={};  %modify/correct

