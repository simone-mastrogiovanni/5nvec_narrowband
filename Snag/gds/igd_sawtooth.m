function g=igd_sawtooth
%IGD_SAWTOOTH  interactive sawtooth or periodic function signal
%
%   interactive call of gd_sawtooth_f(n,dt,T,mima,fun)

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

promptcg1={'Number of samples' 'Sampling time' 'Period' '[min max] value' 'Function'};
defacg1={'1000','1','100','[0 1]','x'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

n=eval(answ{1});
dt=eval(answ{2});
T=eval(answ{3});
mima=eval(answ{4});
fun=answ{5};
g=gd_sawtooth_f(n,dt,T,mima,fun);


