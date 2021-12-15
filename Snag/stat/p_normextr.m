function p=p_normextr(z)
%P_NORMEXTR  computes the standard normal probability to exceed the value z 
%

sqrt2=sqrt(2);
p=erfc(z/sqrt2)/2;