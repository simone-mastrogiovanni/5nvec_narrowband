function obs=check_nonzero(in,nn)
% CHECK_NONZERO  checks for nonzero intervals
%
%    obs=check_nonzero(in,nn)
%
%     in    input gd or array
%     nn    max length of admitted zero interval

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('nn','var')
    nn=20;
end

b=ones(1,nn);

if isa(in,'gd')
    in=y_gd(in);
end

in=filter(b,1,abs(in));

obs=sign(in);