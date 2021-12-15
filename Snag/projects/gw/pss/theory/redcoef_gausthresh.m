function coef=redcoef_gausthresh(Npoint,Ncand)
% REDCOEF_GAUSTHRESH  reduction coefficient in h for thresholding to limit candidate number
%                     (hough transform - gauss dist)
%
%      coef=redcoef_gausthresh(Npoint,Ncand)
%
%    Npoint    number of points in parameter space
%    Ncand     number of desired candidates
%
% The false alarm distribution of h^2 is ideally gaussian with expected value mu=m^2
% and stdev=m.

p=Ncand./Npoint;
if p > 0.5
    coef=1;
    return
end

coef=sqrt(gauss_fa_inv(p));
if coef < 1
    coef=1;
end
