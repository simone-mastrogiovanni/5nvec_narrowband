function out=zero_percent(in)
% computes the zero percentage of a gd or array
%
%    in    input gd, gd2 or array

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isa(in,'gd')
    in=y_gd(in);
end
if isa(in,'gd2')
    in=y_gd2(in);
end

in=in(:);

lenin=length(in);

jj=find(in == 0);
lenjj=length(jj);

out.zeroperc=lenjj/lenin;
out.len=lenin;
out.nzero=lenjj;