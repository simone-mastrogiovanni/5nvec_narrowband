function out=bsd_hole_window(in,onoff,recomp)
% creates a window signal for holes
%
%   in       input bsd
%   onoff    = 1 on window, = 0 off window
%   recomp   = 1 recomputes zeros, otherwise consider the zeros info (default)

% Snag Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if exist('recomp','var')
    if recomp == 1
        in=add_zeros2tfstr(in);
    end
end

tfstr=tfstr_gd(in);
zers=tfstr.zeros;
[nz,~]=size(zers);

x=x_gd(in);

if onoff == 1
    y=x*0+1;
    for i = 1:nz
        j=find(x >= zers(i,1) & x <= zers(i,2));
        y(j)=0;
    end
else
    y=x*0;
    for i = 1:nz
        j=find(x >= zers(i,1) & x <= zers(i,2));
        y(j)=1;
    end
end

out=gd(y);
out=edit_gd(out,'dx',dx_gd(in));