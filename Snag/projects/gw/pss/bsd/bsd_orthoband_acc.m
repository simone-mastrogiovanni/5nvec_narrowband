function [inifr,bandw,dt,iok]=bsd_orthoband(inifrs,bandws,dt0)
% computes the smallest "fine" band for bsds
%
%   inifrs,bandws   signal band

% Snag Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

eps1=2*eps;
k=0;
iok=1;
bandw=1/dt0;

while bandw >= bandws
    k=k+1;
    bandw=1/(dt0*k);
    kk=floor(inifrs/bandw);
    inifr=kk*bandw;
    if inifr+bandw >= inifrs+bandws-eps1
        iok=k;
    end
end

bandw=1/(dt0*iok);
kk=floor(inifrs/bandw);
inifr=kk*bandw;
dt=1/bandw;