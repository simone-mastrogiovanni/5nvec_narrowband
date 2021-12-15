function out=correct_sampling(in,fix,q)
% correct the sample abscissa
%
%    out=correct_sampling(in,fix,q)
%
%  in    input data
%  fix   fixed point (e.g. 0)
%  q     quantum

% Version 2.0 - December 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=round((in-fix)/q)*q+fix;