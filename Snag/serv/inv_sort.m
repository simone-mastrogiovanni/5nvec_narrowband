function [I,A]=inv_sort(ii,aa)
% invert sorting
%
%   ii   sorting index
%   aa   sorted data 
%
%   I    inverse sorting index
%   A    unsorted data

% Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[A,I]=sort(ii);
A=[];

if exist('aa','var')
    A=aa(I);
end