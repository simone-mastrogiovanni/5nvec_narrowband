function runstr=S6LL(k)
% run structure
%
%   k   particular sets

if ~exist('k','var')
    k=1;
end
%%GPS times 931035615 - 971622272. 
runstr.ini=55019.8750000;
runstr.fin=55489.6279745;
%%469.75 days. 
runstr.ant=ligoh;
runstr.run=sprintf('S6LH_%02d',k);

switch k
    case 1
%         runstr.capt='2013 low frequency analysis';
%         runstr.epoch=55111.724090;
%         runstr.st=1/256;
%         runstr.fr.dnat=1/8192;
%         runstr.sd.dnat=7.626998e-12;
%         runstr.sd.min=-13*runstr.sd.dnat;
%         runstr.sd.max=runstr.sd.dnat*2;
%         runstr.fft.len=2097152;
%         runstr.fft.n=3896;
%         runstr.anaband=[20 127 1];
    case 2
        runstr.capt='2013 low frequency extended analysis';
%         runstr.epoch=55111.724090;
%         runstr.st=1/256;
%         runstr.fr.dnat=1/8192;
%         runstr.sd.dnat=7.626998e-12;
%         runstr.sd.min=-20*runstr.sd.dnat;
%         runstr.sd.max=2*runstr.sd.dnat;
%         runstr.fft.len=2097152;
%         runstr.fft.n=3896;
%         runstr.anaband=[20 127 1];
    case 3
        runstr.capt='2014 high frequency analysis';
        runstr.epoch=55254.751487;
        runstr.st=1/4096;
        runstr.fr.dnat=1/1024;
        runstr.sd.dnat=2.40611711e-11;
        runstr.sd.min=-13*runstr.sd.dnat;
        runstr.sd.max=runstr.sd.dnat*2;
        runstr.fft.len=4194304;
        runstr.fft.n=79270;  %%to be changed
        %%/storage/pss/ligo_h/pm/S6/v1/MOCK_DATA_CHALLENGE/v2
        %%(runstr.fin-runstr.ini)*86400/1024=39635. times 2 (overlapped).
        %%We expect < 79270 pms
        %Every 10 days : 10*86400*2/1024=1687 This is correct. In many
        %decades we have 1687 pm. 
        %runstr.anaband=[20 1024 10];
        runstr.anaband=[20 1024 5]; %%
    case 4
%         runstr.capt='2013 high frequency analysis';
%         runstr.epoch=55111.724090;
%         runstr.st=1/4096;
%         runstr.fr.dnat=1/1024;
%         runstr.sd.dnat=7.626998e-12;
%         runstr.sd.min=-13*runstr.sd.dnat;
%         runstr.sd.max=runstr.sd.dnat*2;
%         runstr.fft.len=4194304;
%         runstr.fft.n=3896;
%         runstr.anaband=[1024 2047 10];
end

%%runstr.hw_inj={pulsar_3,pulsar_5,pulsar_10};  %modify/correct
runstr.hw_inj={};  %modify/correct

