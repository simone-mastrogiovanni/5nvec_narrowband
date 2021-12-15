function out=rat_num(in,n0,typ)
% rationalise a number
% 
% out is the nearest number to in, such that out=n/n0 or out=n0/n with n integer
% typ = 1,2,3  lower,central,upper value (def lower)

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=1;
end
if in > n0
    switch typ
        case 1
            out=floor(in/n0)*n0;
        case 2
            out=round(in/n0)*n0;
        case 3
            out=ceil(in/n0)*n0;
    end
elseif in < n0
    switch typ
        case 1
            out=n0/ceil(n0/in);
        case 2
            out=n0/round(n0/in);
        case 3
            out=n0/floor(n0/in);
    end
end
        