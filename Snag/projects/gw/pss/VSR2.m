function runstr=VSR2(k)
% run structure
%
%   k   particular sets

if ~exist('k','var')
    k=1;
end

runstr.ini=55019.6801388;
runstr.fin=55204.9235185;
runstr.ant=virgo;
runstr.run=sprintf('VSR2_%02d',k);

switch k
    case 1
        runstr.capt='2013 low frequency analysis';
        runstr.epoch=55111.724090;
        runstr.st=1/256;
        runstr.fr.dnat=1/8192;
        runstr.sd.dnat=7.626998e-12;
%         runstr.sd.min=-6.864298e-11;
        runstr.sd.min=-13*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;
        runstr.fft.len=2097152;
        runstr.fft.n=3896;
        runstr.anaband=[20 127 1];
    case 2
        runstr.capt='2013 low frequency extended analysis';
        runstr.epoch=55111.724090;
        runstr.st=1/256;
        runstr.fr.dnat=1/8192;
        runstr.sd.dnat=7.626998e-12;
        runstr.sd.min=-20*runstr.sd.dnat;
        runstr.sd.max=2*runstr.sd.dnat;
        runstr.fft.len=2097152;
        runstr.fft.n=3896;
        runstr.anaband=[20 127 1];
    case 3
        runstr.capt='2013 high frequency analysis';
        runstr.epoch=55111.724090;
        runstr.st=1/4096;
        runstr.fr.dnat=1/1024;
        runstr.sd.dnat=7.626998e-12;
        runstr.sd.min=-13*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;
        runstr.fft.len=4194304;
        runstr.fft.n=3896;
        runstr.anaband=[20 1024 10];
    case 4
        runstr.capt='2013 high frequency analysis';
        runstr.epoch=55111.724090;
        runstr.st=1/4096;
        runstr.fr.dnat=1/1024;
        runstr.sd.dnat=7.626998e-12;
        runstr.sd.min=-13*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;
        runstr.fft.len=4194304;
        runstr.fft.n=3896;
        runstr.anaband=[1024 2047 10];
    case 5
        runstr.capt='2015 high frequency analysis';
        runstr.epoch=55111.724090;
        runstr.st=1/4096;
        runstr.fr.dnat=1/1024;
        runstr.sd.dnat=6.1016e-11;
        runstr.sd.min=-13*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;
        runstr.fft.len=4194304;
        runstr.fft.n=3896*8; % check
        runstr.anaband=[20 2047 10];
end

runstr.hw_inj={pulsar_3,pulsar_5,pulsar_10};