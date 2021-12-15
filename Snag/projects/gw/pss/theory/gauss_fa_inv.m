function a=gauss_fa_inv(p)
%GAUSS_INV  computes the standard gaussian false alarm level of probability p
%
%      a=gauss_fa_inv(p)
%
%    p    false alarm probability
%
%    a    false alarm level
%
% The error function erf(X) is twice the integral of
% the Gaussian distribution with 0 mean and variance of 0.5 

a=sqrt(2)*erfcinv(2*p);