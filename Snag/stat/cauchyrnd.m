function Y=cauchyrnd(mu,d,m,n)
% LAPLRND  laplace distribution random numbers

Y=mu+d*tan((rand(m,n)-0.5)*pi);