function out=pss_resid(T,dt,fr0,ant,pos,perr)
% pss residuals for incorrect doppler
%
%   T     [tin tfi] mjd
%   dt    sampling time (s)
%   fr0   frequency
%   ant   antenna structure
%   pos   sky position [ra decl] deg
%   perr  position errors [era edecl] deg

% Snag Version 2.0 - January 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t1=T(1):100/86400:T(2);
out.t1=t1;

fr1=doppler2(t1,fr0,pos(1),pos(2),ant.long,ant.lat,0);
fr2=doppler2(t1,fr0,pos(1)+perr(1),pos(2)+perr(2),ant.long,ant.lat,0);
out.fr1=fr1;
out.fr2=fr2;

fr=spline(t1,fr2-fr1,T(1):dt/86400:T(2));
out.fr=fr;
n=length(fr);

in=exp(1j*(1:n)*dt*2*pi*fr0).';

ph=cumsum(fr)*dt*2*pi;
resid=exp(-1j*ph);
resid=gd(in.*resid(:));
out.resid=edit_gd(resid,'dx',dt);