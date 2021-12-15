function out=bsd_zerointerv(in,zint)
% zeroes intervals (as holes...) of a bds
%
%   out=bsd_zerointerv(in,zint)
%
%   in     input bsd
%   zint   (n,2) couple of indices (start stop)

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[n1,dummy]=size(zint);
y=y_gd(in);

for i = 1:n1
    y(zint(i,1):zint(i,2))=0;
end

out=edit_gd(in,'y',y);