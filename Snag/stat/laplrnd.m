function Y=laplrnd(b,m,n)
% LAPLRND  laplace distribution random numbers

Y=exprnd(b,m,n).*sign(rand(m,n)-0.5);