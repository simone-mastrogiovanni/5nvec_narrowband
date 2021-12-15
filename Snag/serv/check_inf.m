function out=check_inf(in,verbose)
% CHECK_INF  checks Inf data
%
%    out=check_inf(in,verbose)
%
%   in        input data
%   verbose   =1 -> yes
%
%   out       indices for NaN -> 0

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=isinf(in);
out=find(out);

if ~exist('verbose','var')
    verbose=1;
end

if length(out) > 0 && verbose == 1
    fprintf('%d Inf data \n',length(out));
end