function [y,x]=erf_sigmoid(x,d,s)
% double sigmoid function
%
%      y-double_sigm(x,d,s)
%
%    x   abscissas or [min dx max]
%    d   position parameter
%    s   scale parameter

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(x) == 3
    x=x(1):x(2):x(3);
end

y=(erf((x-d)/s)+1)/2;