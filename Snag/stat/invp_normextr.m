function z=invp_normextr(p)
%INVP_NORMEXTR  inverse of p_normextr: value of z for Pr(Z>z)=p 
%

sqrt2=sqrt(2);
z=erfcinv(2*p)*sqrt2;