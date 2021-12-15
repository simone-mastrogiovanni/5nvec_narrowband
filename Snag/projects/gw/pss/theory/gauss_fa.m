function p=gauss_fa(a,exppar)
%GAUSS_FA  computes the standard gaussian false alarm probability for level a
%
%      a=gauss_fa(p)
%
%    a        false alarm level
%    exppar   exponential disturbance [amplitude tau]
%
%    p    false alarm probability
%
% The error function erf(X) is twice the integral of
% the Gaussian distribution with 0 mean and variance of 0.5 

if ~exist('exppar','var')
    exppar=[0 1]; disp('default')
end

p=0.5*erfc(a/sqrt(2));

if exppar > 0
    p=p+exppar(1)*exp(-a./exppar(2));
end