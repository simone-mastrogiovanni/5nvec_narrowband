function v=mvexprnd(MU,SIGMA,n)
% MVEXPRND  random exponential multivariate numbers
%
%     v=mvexprnd(MU,SIGMA,n)
%
%  see mvnrnd

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

v1=mvnrnd(MU,SIGMA,n);
v2=mvnrnd(MU,SIGMA,n);

v=(v1.^2+v2.^2)/2;