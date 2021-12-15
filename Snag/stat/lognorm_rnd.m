function dat=lognorm_rnd(lmu,lsig,N,dt)
% creates lognormal data
%
%    lmu    mu of log
%    lsig   sigma of og
%    N      number of samples
%    dt     sampling time (if present, a gd is created)

% Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

dat=randn(1,N)*lsig+lmu;
dat=10.^dat;

if exist('dt','var')
    dat=gd(dat);
    dat=edit_gd(dat,'dx',dt);
end