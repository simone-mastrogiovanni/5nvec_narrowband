function err=ang_err(ang1,ang2,ic)
% angular difference
%
%    err=ang_err(ang1,ang2,ic)
%
%   ang1,ang2  two angles
%   ic         units: (0 rad, 1 deg (default)
%
%   err        ang2-ang1

% Version 2.0 - April 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ic','var')
    ic=1;
end

if ic == 1
    flatang=180;
else
    flatang=pi;
end

err=mod(ang2-ang1,2*flatang)

if err > flatang
    err=err-2*flatang;
end