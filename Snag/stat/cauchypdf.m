function Y=cauchypdf(x,mu,d)
% CAUCHYPDF  cauchy distribution pdf

Y=(1/(pi*d))./(1+((x-mu)/d).^2);

