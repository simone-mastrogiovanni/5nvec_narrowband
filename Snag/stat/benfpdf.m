function p=benfpdf(base)
% Benford probability distribution
%
%   p=benfpdf(base)
%
%   base    base (def 10)

if ~exist('base','var')
    base=10;
end

p=(log(2:base)-log(1:base-1))/log(base);
