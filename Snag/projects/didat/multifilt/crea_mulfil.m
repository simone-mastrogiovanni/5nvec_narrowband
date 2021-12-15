function mf=crea_mulfil(g,n,typ)
%CREA_MULFIL  creates a multifilter parameter structure
%
%  g       input data gd (time samples)
%  n       number of filters
%  typ     'lin', 'log', ...

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sf=1/dx_gd(g);
bw=0.667*sf/(2*n);

mf.fr(1:n)=0;
mf.bw(1:n)=bw;

if strcmp(typ,'lin')
    mf.fr(1:n)=bw*(1:n);
elseif strcmp(typ,'log')
    bw=0.667*sf/(2*sqrt(2)^n);
    mf.fr(1:n)=bw*sqrt(2).^(1:n);
    mf.bw=mf.fr/2;
end;