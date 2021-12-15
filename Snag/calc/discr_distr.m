function [me st sk ku su]=discr_distr(x,p)
% DISCR_DIST discrete probability distribution parameters
%
%   [me st sk ku su]=discr_distr(x,f)
%
%  x    abscissa values
%  p    probabilities
%
%  me,st,sk,ku,su  mean, st.dev., skewness, kurtosis and sum

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

me=sum(x.*p);
st=sqrt(sum((x-me).^2.*p));
sk=sum((x-me).^3.*p)/st^3;
ku=sum((x-me).^4.*p)/st^4-3;
su=sum(p);