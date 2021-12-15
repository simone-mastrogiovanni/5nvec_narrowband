function [me st sk ku su]=cont_distr(x,f)
% CONT_DIST continuous probability distribution parameters
%
%   [me st sk ku su]=discr_distr(x,f)
%
%  x    abscissa values
%  f    probability distribution
%
%  me,st,sk,ku,su  mean, st.dev., skewness, kurtosis and sum

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

N=length(x);

p(2:N)=(x(2:N)-x(1:N-1)).*f(2:N);
p(1)=f(1)*(x(2)-x(1));
pp=sum(p);
p=p/pp;
me=sum(x.*p);
st=sqrt(sum((x-me).^2.*p));
sk=sum((x-me).^3.*p)/st^3;
ku=sum((x-me).^4.*p)/st^4-3;
su=sum(p);