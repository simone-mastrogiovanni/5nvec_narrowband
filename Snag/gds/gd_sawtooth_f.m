function g=gd_sawtooth_f(n,dt,T,mima,fun)
% saw-tooth signal with function on it
%  
%  This creates any periodic function.
%
%      g=gd_sawtooth_f(n,dt,T,mima,fun)
%
%   n      number of samples
%   dt     sampling time
%   T      period
%   mima   [min max] value (if single value [0 mima])
%   fun    string with the function (on x) (if exist, if absent  fun='x', i.e. no function)

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(mima) == 1
    mima=[0 mima];
end

it=(0:n-1)*dt;
x=mod(it,T)*(mima(2)-mima(1))/T+mima(1);

if exist('fun','var')
    eval(['x=' fun ';']);
end

g=gd(x);
g=edit_gd(g,'dx',dt);