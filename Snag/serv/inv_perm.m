function [I,A]=inv_perm(ii,aa)
% invert permutation
% to invert multiple permutation, input the perm1(perm2(perm3(...)))
%
%   ii   permutation 
%   aa   permuted data 
%
%   I    inverse permuting index
%   A    unpermuted data

% Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[A,I]=sort(ii);
A=[];

if exist('aa','var')
    A=aa(I);
end