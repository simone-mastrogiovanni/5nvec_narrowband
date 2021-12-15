function v5out=transf_5vec(v5in,phi0,phi1)
% trasf_5vec  transform a 5-vect in an equivalent
%
%   trasf_5vec(v5in,phi0,phi1)
%
%   phi0,phi1   degrees

for i = 1:5
    k=i-3;
    v5out(i)=v5in(i)*exp(1j*(phi0+k*phi1)*pi/180);
end