function vpar=pss_lsc2virgo_par(lpar)
%
%   in:   lpar.apl,lpar.acr or lpar.a0 lpar.cosiota
%
%   out:  vpar.eta,vpar.h0 

if isfield(lpar,'apl')
    vpar.eta=-lpar.acr/lpar.apl;
    eta=vpar.eta+eps;
    cosiota=(1/eta)*(1-sqrt(1-eta^2));
    A=sqrt(1+6*cosiota^2+cosiota^4)/2;
    vpar.h0=sqrt(lpar.acr^2+lpar.apl^2);
    vpar.h0L=vpar.h0/A;
else
    vpar.eta=-2*lpar.cosiota/(1+lpar.cosiota^2);
    vpar.h0=lpar.a0*sqrt(1+6*lpar.cosiota^2+lpar.cosiota^4)/2;
end