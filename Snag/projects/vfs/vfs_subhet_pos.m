function [out,frcorr]=vfs_subhet_pos(in,fr,pos)
% application of sub-heterodyne
%
%    [out,lfr]=vfs_subhet_pos(in,fr,pos)
%
%   in    input data gd
%   fr    frequency (fixed, varying or spin-down [f df ddf ...])
%   pos   position (normalized by c)

% Version 2.0 - October 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(in);
n=n_gd(in);

nfr=length(fr);

switch nfr
    case 1
        ph=pos*fr*2*pi;
    case n
        ph=pos.*fr*2*pi;
    otherwise
        fr0=fr(1);
        fr=vfs_spindown([dt,n],fr(2:nfr),1)+fr0;
        ph=pos.*fr'*2*pi;
end
corr=exp(-1j*ph);
out=y_gd(in).*corr(:);
out=edit_gd(in,'y',out);
frcorr=diff(ph)*dt;