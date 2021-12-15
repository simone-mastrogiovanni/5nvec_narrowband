function Y=ricepdf(x,nu,sig)
% RICEPDF  Rice distribution pdf

Y=(x/sig^2).*exp(-(x.^2+nu^2)/(2*sig^2)).*besseli(0,x*nu/sig^2);

