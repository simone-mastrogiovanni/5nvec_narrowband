function X=x_5vec(norm)
% X_5VEC  creates an X-type 5-vector
%
%   X=x_5vec(norm);
%
%   norm   if > 0, value of |X|^2
%          if absent, |X|^2=1
%          if = 0, E[|X|^2]=5

if ~exist('norm','var')
    norm=0;
end

X(1:5)=(randn(1,5)+1j*randn(1,5))/sqrt(10);

if norm > 0
    X=norm*X/sqrt(sum(abs(X).^2));
end