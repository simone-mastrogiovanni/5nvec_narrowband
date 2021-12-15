function dpol=polyder(pol)
% Calcola la derivata di un polinomio
%
%   pol    coefficienti del polinomio (dalla potenza più slta alla 0-esima)
%
%   dpol   coefficienti della derivata (dalla potenza più slta alla 0-esima)

N=length(pol)-1;
dpol=pol(1:N)*0;
if N == 0 then
    dpol=0;
end
for i = 1:N
    dpol(i)=(N-i+1)*pol(i);
end
