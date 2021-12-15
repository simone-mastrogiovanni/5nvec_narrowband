function [m,ir,ic]=maxmat(M)
% finds the maximum of a matrix
%
%   [m,ir,ic]=maxmat(M)
%
%  m   max
%  ir  row
%  ic  col

% Version 2.0 - July 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

[m IR]=max(M);
[m ic]=max(m);
ir=IR(ic);