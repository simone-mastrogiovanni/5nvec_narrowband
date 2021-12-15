function [m,i,j]=find_max(matr)
%FIND_MAX  finds the absolute maximum of a matrix
%
%   matr   input matrix
%
%   m      maximum
%   i,j    indices

% Version 2.0 - September 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

m=max(matr(:));

[i,j]=find(matr == m);

