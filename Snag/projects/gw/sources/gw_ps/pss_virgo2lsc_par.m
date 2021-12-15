function vpar=pss_virgo2lsc_par(lpar)
%
%   in:   lpar.apl,lpar.acr
%
%   out:  vpar.eta,vpar.h0

% vpar.eta=-lpar.acr/lpar.apl;
% eta=vpar.eta+eps;
% cosiota=(1/eta)*(1-sqrt(1-eta^2));
% A=sqrt(1+6*cosiota^2+cosiota^4)/2;
% vpar.h0=sqrt(lpar.acr^2+lpar.apl^2);
% vpar.h0L=vpar.h0/A;