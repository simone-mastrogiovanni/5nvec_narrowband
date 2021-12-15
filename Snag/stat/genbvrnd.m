function v=genbvrnd(x,fun,sig)
% GENMVRND  general bivariate random data
%
%     v=genbvrnd(x,fun,sig)
%
%   x     x random data
%   fun   string containing the y definition ('y=...')
%   sig   polinomial of x defining the sigma

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

eval(fun);
r=polyval(sig,x).*randn(length(x),1);
v(:,1)=x;
v(:,2)=y+r;
