function runstr=VSR4(k)
% run structure
%
%   k   particular sets
%


if ~exist('k','var')
    k=1;
end

runstr.ini=55715.4350115;
runstr.fin=55809.5220486;
runstr.ant=virgo;
runstr.run=sprintf('VSR4_%02d',k);

switch k
    case 1
        runstr.capt='2013 low frequency analysis';
        runstr.epoch=55761.948247;
        runstr.st=1/256;
        runstr.fr.dnat=1/8192;
        runstr.sd.dnat=1.501642e-11;
%         runstr.sd.min=-1.351478e-10;
        runstr.sd.min=-7*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat;
        runstr.fft.len=2097152;
        runstr.fft.n=1978;
        runstr.anaband=[20 127 1];
    case 5
        runstr.capt='2015 high frequency analysis';
        runstr.epoch=55761.948247;
        runstr.st=1/4096;
        runstr.fr.dnat=1/1024;
        runstr.sd.dnat=1.2013e-10;
        runstr.sd.min=-7*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat;
        runstr.fft.len=4194304;
        runstr.fft.n=1978*8;  % check
        runstr.anaband=[20 2047 10];
end

runstr.hw_inj={pulsar_3,pulsar_5,pulsar_10};