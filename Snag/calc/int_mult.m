function [out,mult]=int_mult(in,n0,typ)
% integer multiple of a number
% 
% out is the nearest number to in, such that out=n*n0 with n integer
% typ = 1,2,3  lower,central,upper value (def central)

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=2;
end

switch typ
    case 1
        mult=floor(in/n0);
        out=mult*n0;
    case 2
        mult=round(in/n0);
        out=mult*n0;
    case 3
        mult=ceil(in/n0);
        out=mult*n0;
end
        