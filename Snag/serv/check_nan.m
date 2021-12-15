function out=check_nan(in,verbose)
% CHECK_NAN  checks NaN data
%
%    out=check_nan(in,verbose)
%
%   in        input data
%   verbose   =1 -> yes
%
%   out       indices for NaN -> 0

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=isnan(in);
out=find(out);

if ~exist('verbose','var')
    verbose=1;
end

if length(out) > 0 && verbose == 1
    fprintf('%d Nan data \n',length(out));
end